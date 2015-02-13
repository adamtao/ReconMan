class AddDocsDeliveredOnToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :docs_delivered_on, :date
  end
end
