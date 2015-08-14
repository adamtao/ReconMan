class AddJobTypeFieldsToJobProducts < ActiveRecord::Migration
  def change
  	add_column :job_products, :deed_of_trust_number, :string
  	add_column :job_products, :developer, :string
  	add_column :job_products, :parcel_number, :string
  	add_column :job_products, :beneficiary_name, :string
  	add_monetize :job_products, :payoff_amount
  	add_column :job_products, :beneficiary_account, :string
  	add_column :job_products, :parcel_legal_description, :string

    if defined?(JobProduct)
      JobProduct.all.each do |jp|

        jp.parcel_number = jp.job.parcel_number
        jp.parcel_legal_description = jp.job.parcel_legal_description
        jp.beneficiary_name = jp.job.beneficiary_name
        jp.payoff_amount_cents = jp.job.payoff_amount_cents
        jp.payoff_amount_currency = jp.job.payoff_amount_currency
        jp.beneficiary_account = jp.job.beneficiary_account
        jp.deed_of_trust_number = jp.job.deed_of_trust_number
        jp.developer = jp.job.developer
        jp.save

      end
    end

  	remove_column :jobs, :parcel_number
  	remove_column :jobs, :beneficiary_name
  	remove_column :jobs, :payoff_amount_cents
  	remove_column :jobs, :payoff_amount_currency
  	remove_column :jobs, :beneficiary_account
  	remove_column :jobs, :parcel_legal_description
  	remove_column :jobs, :deed_of_trust_number, :string
  	remove_column :jobs, :developer, :string
  end
end
