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
      @error_message = friendly_error(e)
      respond_to do |format|
        format.turbo_stream { render :error, status: :service_unavailable }
        format.html { redirect_to book_path(@book), alert: @error_message }
      end
    end

    private

    # Map technical errors to calm, user-facing copy. Never leak raw API output.
    def friendly_error(error)
      case error
      when GeminiClient::QuotaError
        "The AI is taking a breather — its usage limit was reached. Please try again in a few minutes."
      when GeminiClient::AuthError
        "The AI service isn't configured correctly. Please let an admin know."
      when GeminiClient::ModelError
        "The AI model is currently unavailable. Please let an admin know."
      else
        "Sorry — something went wrong answering that. Please try again."
      end
    end
  end
end
