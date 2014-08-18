class AddExtraFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :client_type, :string
    add_column :clients, :website, :string
  end
end
