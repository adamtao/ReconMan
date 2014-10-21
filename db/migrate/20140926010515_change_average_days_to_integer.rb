class ChangeAverageDaysToInteger < ActiveRecord::Migration
  def change
    remove_column :counties, :average_days_to_complete
    add_column :counties, :average_days_to_complete, :integer

  end
end
