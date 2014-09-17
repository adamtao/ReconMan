class AddJobTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :job_type, :string
    add_index :products, :job_type
  end
end
