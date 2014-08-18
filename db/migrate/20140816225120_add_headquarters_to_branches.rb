class AddHeadquartersToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :headquarters, :boolean, default: false
  end
end
