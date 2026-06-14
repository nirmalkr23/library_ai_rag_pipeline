class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author
      t.integer :status, null: false, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
