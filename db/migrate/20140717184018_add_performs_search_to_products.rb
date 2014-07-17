class AddPerformsSearchToProducts < ActiveRecord::Migration
  def change
    add_column :products, :performs_search, :boolean
  end
end
