# Splits long text into overlapping chunks suitable for embedding.
# Greedy by paragraph, falling back to hard splits for very long paragraphs.
class TextChunker
  def self.call(text, max_chars: 1000, overlap: 150)
    new(max_chars:, overlap:).call(text)
  end

  def initialize(max_chars:, overlap:)
    @max_chars = max_chars
    @overlap = overlap
  end

  def call(text)
    clean = text.to_s.gsub(/\r\n?/, "\n").gsub(/[ \t]+/, " ").strip
    return [] if clean.empty?

    chunks = []
    buffer = +""

    clean.split(/\n{2,}/).each do |para|
      para = para.strip
      next if para.empty?

      if para.length > @max_chars
        flush(chunks, buffer); buffer = +""
        hard_split(para).each { |piece| chunks << piece }
      elsif buffer.length + para.length + 1 > @max_chars
        flush(chunks, buffer)
        buffer = tail(chunks.last) + para
      else
        buffer << "\n\n" unless buffer.empty?
        buffer << para
      end
    end
    flush(chunks, buffer)
    chunks
  end

  private

  def flush(chunks, buffer)
    text = buffer.strip
    chunks << text unless text.empty?
  end

  # Carry the last `overlap` chars of the previous chunk into the next one
  # so context isn't lost at boundaries.
  def tail(prev)
    return "" if prev.nil? || @overlap.zero?

    prev[-@overlap..].to_s + "\n\n"
  end

  def hard_split(para)
    para.chars.each_slice(@max_chars).map(&:join)
  end
end
