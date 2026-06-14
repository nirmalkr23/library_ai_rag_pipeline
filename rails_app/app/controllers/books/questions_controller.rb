module Books
  class QuestionsController < ApplicationController
    before_action :authenticate_user!

    def create
      @book = Book.ready.find(params[:book_id])
      question = params.dig(:chat_history, :question).to_s.strip

      if question.blank?
        return redirect_to book_path(@book), alert: "Please type a question."
      end

      result = BookQa.new(@book).answer(question)
      @chat_history = @book.chat_histories.create!(
        user: current_user,
        question: question,
        answer: result[:answer]
      )

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@book) }
      end
    rescue StandardError => e
      Rails.logger.error("[Books::Questions] #{e.class}: #{e.message}")
      redirect_to book_path(@book), alert: "Sorry — couldn't answer that right now. (#{e.message})"
    end
  end
end
