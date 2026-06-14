class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.ready.order(created_at: :desc)
  end

  def show
    @book = Book.ready.find(params[:id])
    @chat_histories = @book.chat_histories.where(user: current_user).chronological
    @chat_history = ChatHistory.new
  end
end
