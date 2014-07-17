class CreateClientProducts < ActiveRecord::Migration
  def change
    create_table :client_products do |t|
      t.integer :client_id
      t.integer :product_id
      t.money :price

      t.timestamps
    end
    add_index :client_products, :client_id
    add_index :client_products, :product_id
  end
end
