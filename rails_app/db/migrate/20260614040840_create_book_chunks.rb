class CreateBookChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :book_chunks do |t|
      t.references :book, null: false, foreign_key: { on_delete: :cascade }
      t.text :content, null: false
      t.integer :position, null: false
      t.vector :embedding, limit: 768 # Gemini text-embedding-004

      t.timestamps
    end

    # Approximate nearest-neighbor index for cosine similarity search.
    add_index :book_chunks, :embedding, using: :hnsw, opclass: :vector_cosine_ops
  end
end
