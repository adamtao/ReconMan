class AddHeadquartersToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :headquarters, :boolean
  end
end
