# Retrieval-augmented QA over a single book's chunks.
#   embed question -> pgvector nearest-neighbor search -> Gemini Flash answer.
class BookQa
  TOP_K = 6

  def initialize(book, client: GeminiClient.new)
    @book = book
    @client = client
  end

  # Returns { answer: String, sources: [BookChunk, ...] }.
  def answer(question)
    qvec = @client.embed_query(question)
    sources = @book.book_chunks
                   .nearest_neighbors(:embedding, qvec, distance: "cosine")
                   .first(TOP_K)

    answer = @client.generate(prompt_for(question, sources))
    { answer: answer.presence || "I couldn't generate an answer. Please try rephrasing.", sources: sources }
  end

  private

  def prompt_for(question, sources)
    context = sources.map.with_index(1) { |c, i| "[#{i}] #{c.content}" }.join("\n\n")

    <<~PROMPT
      You are a helpful assistant answering questions about the book "#{@book.title}"#{@book.author.present? ? " by #{@book.author}" : ""}.
      Answer the question using ONLY the context passages below. The passages are
      numbered — cite the ones you use like [1], [2]. If the answer is not in the
      context, say you couldn't find it in this book. Be concise and clear.

      Context:
      #{context}

      Question: #{question}

      Answer:
    PROMPT
  end
end
