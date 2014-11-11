class AddBilledStatusToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :billed, :boolean, default: false
  end
end
