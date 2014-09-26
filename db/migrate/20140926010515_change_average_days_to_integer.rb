class ChangeAverageDaysToInteger < ActiveRecord::Migration
  def change
    change_column :counties, :average_days_to_complete, :integer
  end
end
