class AddCheckoutToCounties < ActiveRecord::Migration
  def change
    add_column :counties, :checked_out_to_id, :integer
    add_index :counties, :checked_out_to_id
    add_column :counties, :checked_out_at, :datetime
  end
end
