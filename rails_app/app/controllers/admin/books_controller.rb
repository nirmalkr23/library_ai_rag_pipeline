module Admin
  class BooksController < BaseController
    def index
      @books = Book.order(created_at: :desc)
    end

    def new
      @book = Book.new
    end

    def create
      @book = Book.new(book_params)
      @book.user = current_user

      unless @book.save
        flash.now[:alert] = @book.errors.full_messages.to_sentence
        return render :new, status: :unprocessable_entity
      end

      title = @book.title
      # Run synchronously for now (perform_now). On failure the job deletes the
      # book + PDF, so nothing is left to duplicate on a retry.
      ProcessBookJob.perform_now(@book.id)

      redirect_to admin_books_path, notice: "“#{title}” processed and added to the library."
    rescue StandardError => e
      @book = Book.new
      flash.now[:alert] = "Processing failed: #{e.message}"
      render :new, status: :unprocessable_entity
    end

    def destroy
      book = Book.find(params[:id])
      book.destroy
      redirect_to admin_books_path, notice: "Book deleted."
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :pdf)
    end
  end
end
