class AddCellphoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cell_phone, :string
  end
end
