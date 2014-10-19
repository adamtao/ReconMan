class CreateSearchLogs < ActiveRecord::Migration
  def change
    create_table :search_logs do |t|
      t.integer :job_product_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end
    add_index :search_logs, :job_product_id
  end
end
