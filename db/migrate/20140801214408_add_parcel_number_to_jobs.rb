class AddParcelNumberToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :parcel_number, :string
    add_index :jobs, :parcel_number
  end
end
