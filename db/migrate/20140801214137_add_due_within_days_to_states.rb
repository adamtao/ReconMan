class AddDueWithinDaysToStates < ActiveRecord::Migration
  def change
    add_column :states, :due_within_days, :integer
  end
end
