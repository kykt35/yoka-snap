class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :area, null: false
      t.string :address, null: false
      t.string :recommended_time
      t.string :status, null: false, default: "published"

      t.timestamps
    end
    add_index :posts, :status
    add_index :posts, :area
  end
end
