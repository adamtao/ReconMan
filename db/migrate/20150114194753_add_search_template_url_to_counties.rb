class AddSearchTemplateUrlToCounties < ActiveRecord::Migration
  def change
    add_column :counties, :search_template_url, :string
  end
end
