class CreateZipcodes < ActiveRecord::Migration
  def change
    create_table :zipcodes do |t|
      t.string :zipcode
      t.string :zip_type
      t.string :primary_city
      t.text :acceptable_cities
      t.text :unacceptable_cities
      t.string :state
      t.string :county
      t.string :timezone
      t.text :area_codes
      t.float :latitude
      t.float :longitude
      t.string :world_region
      t.string :country
      t.boolean :decommissioned
      t.integer :estimated_population
      t.text :notes

      t.timestamps
    end
    add_index :zipcodes, :zipcode
  end
end
