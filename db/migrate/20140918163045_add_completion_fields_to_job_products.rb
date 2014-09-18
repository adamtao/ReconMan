class AddCompletionFieldsToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :new_deed_of_trust_number, :string
    add_column :job_products, :recorded_on, :date
  end
end
