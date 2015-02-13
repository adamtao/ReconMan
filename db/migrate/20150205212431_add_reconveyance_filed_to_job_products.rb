class AddReconveyanceFiledToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :reconveyance_filed, :boolean
  end
end
