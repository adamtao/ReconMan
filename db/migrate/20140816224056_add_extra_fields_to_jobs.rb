class AddExtraFieldsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :escrow_number, :string
    add_column :jobs, :close_on, :date
    add_column :jobs, :beneficiary_name, :string
    add_monetize :jobs, :payoff_amount
    add_column :jobs, :beneficiary_account, :string
    add_column :jobs, :underwriter_name, :string
    add_column :jobs, :short_sale, :boolean, default: false
    add_column :jobs, :file_type, :string
    add_column :jobs, :parcel_legal_description, :string
  end
end
