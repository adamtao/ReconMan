class ModifyJobFields < ActiveRecord::Migration
  def change
  	rename_column :jobs, :escrow_number, :file_number
  	add_column :jobs, :deed_of_trust_number, :string
  	add_column :jobs, :developer, :string
  	add_column :jobs, :job_type, :string, default: 'tracking'
  end
end
