class CreateTitleSearchCaches < ActiveRecord::Migration
  def change
    create_table :title_search_caches do |t|
      t.integer :job_id
      t.text :response

      t.timestamps
    end
    add_index :title_search_caches, :job_id
  end
end
