class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :job_product_id
      t.string :file_file_name
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.string :file_content_type

      t.timestamps
    end
    add_index :documents, :job_product_id
  end
end
