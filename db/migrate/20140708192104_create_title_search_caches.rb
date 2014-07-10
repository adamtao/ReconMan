class CreateTitleSearchCaches < ActiveRecord::Migration
  def change
    create_table :title_search_caches do |t|
      t.integer :job_product_id
      t.text :content

      t.timestamps
    end
    add_index :title_search_caches, :job_product_id
  end
end
