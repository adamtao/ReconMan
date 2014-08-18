class AddPerformsSearchToProducts < ActiveRecord::Migration
  def change
    add_column :products, :performs_search, :boolean, default: false
  end
end
