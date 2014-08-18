class AddBillingAddressToClients < ActiveRecord::Migration
  def change
    add_column :clients, :billing_address, :string
    add_column :clients, :billing_city, :string
    add_column :clients, :billing_state_id, :integer
    add_column :clients, :billing_zipcode, :string
  end
end
