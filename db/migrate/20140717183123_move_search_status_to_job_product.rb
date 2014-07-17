class MoveSearchStatusToJobProduct < ActiveRecord::Migration
  def up
  	add_column :job_products, :last_search_at, :datetime
  	remove_column :jobs, :last_search_at
  end

  def down
  	add_column :jobs, :last_search_at, :datetime
  	remove_column :job_products, :last_search_at
  end
end
