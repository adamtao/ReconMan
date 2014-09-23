class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :message
      t.integer :user_id
      t.integer :related_id
      t.string :related_type

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, [:related_id, :related_type]
  end
end
