class AddExtraFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_contact, :boolean
    add_column :users, :billing_contact, :boolean
    add_column :users, :phone, :string
  end
end
