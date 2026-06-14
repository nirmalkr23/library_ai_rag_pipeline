require "net/http"
require "json"
require "uri"

# Thin HTTP client for the Google Gemini API.
# Embeddings: text-embedding-004 (768-dim). Chat: gemini-2.0-flash.
#
# NOTE: free-tier key with a hard rate limit. Only call this from real user
# actions (UI-triggered jobs) — never from test/verification scripts.
class GeminiClient
  BASE = "https://generativelanguage.googleapis.com/v1beta"
  EMBED_BATCH = 100 # Gemini batchEmbedContents cap
  EMBED_DIM = 768   # must match the book_chunks.embedding vector(768) column

  class Error < StandardError
    attr_reader :status

    def initialize(message, status: nil)
      @status = status
      super(message)
    end
  end

  class QuotaError < Error; end      # 429 — rate limit / quota exceeded
  class AuthError < Error; end       # 401/403 — bad key / blocked
  class ModelError < Error; end      # 404 — model not found/unsupported

  def initialize(api_key: ENV["GEMINI_API_KEY"],
                 embedding_model: ENV.fetch("GEMINI_EMBEDDING_MODEL", "gemini-embedding-001"),
                 chat_model: ENV.fetch("GEMINI_CHAT_MODEL", "gemini-2.0-flash"))
    raise Error, "GEMINI_API_KEY is not set" if api_key.blank?

    @api_key = api_key
    @embedding_model = embedding_model
    @chat_model = chat_model
  end

  # Returns an array of embedding vectors (one Array<Float> per input text),
  # in the same order as the inputs. Batches to respect the API cap.
  def embed(texts)
    Array(texts).each_slice(EMBED_BATCH).flat_map { |batch| embed_batch(batch) }
  end

  # Embed a search query (uses RETRIEVAL_QUERY task type) -> Array<Float>.
  def embed_query(text)
    body = {
      model: "models/#{@embedding_model}",
      content: { parts: [{ text: text }] },
      taskType: "RETRIEVAL_QUERY",
      outputDimensionality: EMBED_DIM
    }
    res = post("models/#{@embedding_model}:embedContent", body)
    res.dig("embedding", "values")
  end

  # Single-prompt chat completion -> String answer.
  def generate(prompt)
    body = { contents: [{ parts: [{ text: prompt }] }] }
    res = post("models/#{@chat_model}:generateContent", body)
    res.dig("candidates", 0, "content", "parts", 0, "text").to_s
  end

  private

  def embed_batch(batch)
    body = {
      requests: batch.map do |text|
        {
          model: "models/#{@embedding_model}",
          content: { parts: [{ text: text }] },
          taskType: "RETRIEVAL_DOCUMENT",
          outputDimensionality: EMBED_DIM
        }
      end
    }
    res = post("models/#{@embedding_model}:batchEmbedContents", body)
    res.fetch("embeddings").map { |e| e.fetch("values") }
  end

  def post(path, body)
    uri = URI("#{BASE}/#{path}")
    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req["x-goog-api-key"] = @api_key
    req.body = body.to_json

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, read_timeout: 120) do |http|
      http.request(req)
    end

    unless res.is_a?(Net::HTTPSuccess)
      raise error_for(res.code.to_i, "Gemini #{path} failed: #{res.code} #{res.body&.slice(0, 300)}")
    end

    JSON.parse(res.body)
  end

  def error_for(status, message)
    klass = case status
            when 429 then QuotaError
            when 401, 403 then AuthError
            when 404 then ModelError
            else Error
            end
    klass.new(message, status: status)
  end
end
