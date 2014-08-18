class AddDefaultFlagToProducts < ActiveRecord::Migration
  def change
    add_column :products, :default, :boolean, default: false
  end
end
