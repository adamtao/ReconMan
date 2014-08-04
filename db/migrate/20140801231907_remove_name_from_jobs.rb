class RemoveNameFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :name, :string
  end
end
