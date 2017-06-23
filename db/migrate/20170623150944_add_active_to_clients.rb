class AddActiveToClients < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :active, :boolean, default: true
    Client.update_all(active: true)
  end
end
