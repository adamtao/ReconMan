class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name
      t.string :address
      t.string :city
      t.integer :state_id
      t.string :zipcode
      t.string :phone
      t.integer :client_id

      t.timestamps
    end
    add_index :branches, :client_id
  end
end
