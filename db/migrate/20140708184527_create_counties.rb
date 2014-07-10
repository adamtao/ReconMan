class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
      t.integer :state_id
      t.string :search_url
      t.string :search_params
      t.string :search_method
      t.string :average_days_to_complete

      t.timestamps
    end
    add_index :counties, :state_id
  end
end
