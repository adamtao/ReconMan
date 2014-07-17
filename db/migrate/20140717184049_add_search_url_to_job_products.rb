class AddSearchUrlToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :search_url, :string
  end
end
