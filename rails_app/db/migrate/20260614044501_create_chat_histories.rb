class CreateChatHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
