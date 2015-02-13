class RenameJobProductIds < ActiveRecord::Migration
  def change
    remove_index :documents, :job_product_id
    rename_column :documents, :job_product_id, :task_id
    add_index :documents, :task_id

    remove_index :search_logs, :job_product_id
    rename_column :search_logs, :job_product_id, :task_id
    add_index :search_logs, :task_id

    remove_index :title_search_caches, :job_product_id
    rename_column :title_search_caches, :job_product_id, :task_id
    add_index :title_search_caches, :task_id

  end
end
