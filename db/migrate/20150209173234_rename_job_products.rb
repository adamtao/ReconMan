class RenameJobProducts < ActiveRecord::Migration
  def up
    rename_table :job_products, :tasks
    add_column :tasks, :type, :string
    add_index :tasks, :type
  end

  def down
    remove_index :tasks, :type
    remove_column :tasks, :type
    rename_table :tasks, :job_products
  end
end
