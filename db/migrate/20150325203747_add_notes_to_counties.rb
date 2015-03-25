class AddNotesToCounties < ActiveRecord::Migration
  def change
    add_column :counties, :notes, :text
  end
end
