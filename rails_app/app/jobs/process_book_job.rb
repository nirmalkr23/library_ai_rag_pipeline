require "pdf/reader"

# Ingests an uploaded book into the RAG store:
#   extract PDF text -> chunk -> embed (Gemini) -> store vectors in pgvector.
#
# On ANY failure the book record AND its attached PDF are deleted, so a failed
# upload leaves nothing behind (no duplicates on retry). The error is re-raised
# so a synchronous (perform_now) caller can report it.
class ProcessBookJob < ApplicationJob
  queue_as :default

  class ProcessingError < StandardError; end

  def perform(book_id)
    book = Book.find_by(id: book_id)
    return if book.nil?

    book.processing!

    text = extract_text(book)
    raise ProcessingError, "No extractable text found in the PDF." if text.blank?

    chunks = TextChunker.call(text)
    raise ProcessingError, "Could not split the PDF into text chunks." if chunks.empty?

    embeddings = GeminiClient.new.embed(chunks)
    if embeddings.size != chunks.size
      raise ProcessingError, "Embedding count (#{embeddings.size}) != chunk count (#{chunks.size})."
    end

    store_chunks(book, chunks, embeddings)
    book.ready!
  rescue StandardError => e
    cleanup!(book)
    Rails.logger.error("[ProcessBookJob] book=#{book_id} failed: #{e.class}: #{e.message}")
    raise
  end

  private

  def extract_text(book)
    book.pdf.open do |file|
      reader = PDF::Reader.new(file)
      reader.pages.map(&:text).join("\n\n")
    end
  end

  def store_chunks(book, chunks, embeddings)
    Book.transaction do
      book.book_chunks.delete_all # idempotent on reprocess
      chunks.each_with_index do |content, i|
        book.book_chunks.create!(content: content, position: i, embedding: embeddings[i])
      end
    end
  end

  # Remove the book and its PDF blob entirely.
  def cleanup!(book)
    return if book.nil? || book.destroyed?

    book.pdf.purge if book.pdf.attached?
    book.destroy
  rescue StandardError => e
    Rails.logger.error("[ProcessBookJob] cleanup failed: #{e.class}: #{e.message}")
  end
end
