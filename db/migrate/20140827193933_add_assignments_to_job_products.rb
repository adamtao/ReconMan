class AddAssignmentsToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :worker_id, :integer
    add_index :job_products, :worker_id
  end
end
