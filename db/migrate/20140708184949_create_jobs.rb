class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.integer :client_id
      t.string :address
      t.string :city
      t.integer :state_id
      t.string :zipcode
      t.integer :county_id
      t.datetime :last_search_at
      t.datetime :completed_at
      t.string :old_owner
      t.string :new_owner
      t.string :workflow_state
      t.integer :requestor_id

      t.timestamps
    end
    add_index :jobs, :client_id
    add_index :jobs, :county_id
    add_index :jobs, :requestor_id
  end
end
