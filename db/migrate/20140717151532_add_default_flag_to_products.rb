class AddDefaultFlagToProducts < ActiveRecord::Migration
  def change
    add_column :products, :default, :boolean
  end
end
