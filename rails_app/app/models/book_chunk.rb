class BookChunk < ApplicationRecord
  belongs_to :book
  has_neighbors :embedding

  validates :content, presence: true
end
