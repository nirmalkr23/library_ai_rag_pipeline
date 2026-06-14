class Book < ApplicationRecord
  belongs_to :user, optional: true # uploader (admin)
  has_one_attached :pdf
  has_many :book_chunks, dependent: :destroy
  has_many :chat_histories, dependent: :destroy

  # Processing lifecycle for the RAG pipeline (extraction -> chunk -> embed).
  enum :status, { pending: 0, processing: 1, ready: 2, failed: 3 }

  validates :title, presence: true
  validate :pdf_presence_and_type

  private

  def pdf_presence_and_type
    return errors.add(:pdf, "must be attached") unless pdf.attached?
    return if pdf.content_type == "application/pdf"

    errors.add(:pdf, "must be a PDF file")
  end
end
