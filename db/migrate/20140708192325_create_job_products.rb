class CreateJobProducts < ActiveRecord::Migration
  def change
    create_table :job_products do |t|
      t.integer :product_id
      t.integer :job_id
      t.money :price
      t.string :workflow_state

      t.timestamps
    end
    add_index :job_products, :product_id
    add_index :job_products, :job_id
  end
end
