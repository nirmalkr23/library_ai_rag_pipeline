class ChatHistory < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :question, presence: true

  scope :chronological, -> { order(created_at: :asc) }
end
