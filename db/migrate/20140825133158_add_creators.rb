class AddCreators < ActiveRecord::Migration
  def change
  	add_column :jobs, :created_by_id, :integer
  	add_column :clients, :created_by_id, :integer
  	add_column :branches, :created_by_id, :integer
  	add_column :products, :created_by_id, :integer
  	add_column :job_products, :created_by_id, :integer
  	add_column :client_products, :created_by_id, :integer

  	add_column :jobs, :modified_by_id, :integer
  	add_column :clients, :modified_by_id, :integer
  	add_column :branches, :modified_by_id, :integer
  	add_column :products, :modified_by_id, :integer
  	add_column :job_products, :modified_by_id, :integer
  	add_column :client_products, :modified_by_id, :integer

  	add_index :jobs, :created_by_id
  	add_index :clients, :created_by_id
  	add_index :job_products, :created_by_id
  	add_index :jobs, :modified_by_id
  	add_index :clients, :modified_by_id
  	add_index :job_products, :modified_by_id
  end
end
