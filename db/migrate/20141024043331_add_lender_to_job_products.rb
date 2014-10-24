class AddLenderToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :lender_id, :integer
    add_index :job_products, :lender_id

    JobProduct.all.each do |jp|
      jp.lender_id = Lender.where(name: jp.beneficiary_name).first_or_create.id
      jp.save
    end
  end
end
