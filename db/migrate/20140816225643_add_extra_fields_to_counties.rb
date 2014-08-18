class AddExtraFieldsToCounties < ActiveRecord::Migration
  def change
    add_column :counties, :phone, :string
    add_column :counties, :fax, :string
    add_column :counties, :webpage, :string
    add_column :counties, :contact_name, :string
    add_column :counties, :contact_phone, :string
    add_column :counties, :contact_email, :string
    add_column :counties, :assessor_webpage, :string
    add_column :counties, :zip_codes, :text
    add_column :counties, :co_fee_schedule, :boolean
    add_column :counties, :simplifile, :boolean
    add_column :counties, :s_contact_name, :string
    add_column :counties, :s_contact_phone, :string
    add_column :counties, :s_contact_email, :string
  end
end
