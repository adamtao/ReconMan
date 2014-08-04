class AddDueOnToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :due_on, :date
  end
end
