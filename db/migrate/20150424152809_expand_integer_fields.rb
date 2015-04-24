class ExpandIntegerFields < ActiveRecord::Migration
  def change
    change_column(:tasks, :payoff_amount_cents, :integer, limit: 8)
    change_column(:documents, :file_file_size, :integer, limit: 8)
  end
end
