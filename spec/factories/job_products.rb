# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job_product do
    product
    job
    price_cents 1995
		# last_search_at
		# search_url
		due_on 1.month.from_now
    # association :creator, factory: :user
    # association :modifier, factory: :user
    association :worker, factory: :user
		sequence(:deed_of_trust_number) {|n| "#{n}"}
		developer "MyDeveloper"
		sequence(:parcel_number) {|p| "#{p}"}
		beneficiary_name "MyBeneficiary"
		payoff_amount_cents 11111
		sequence(:beneficiary_account) {|a| "#{a}"}
		parcel_legal_description "Residential property"
		# new_deed_of_trust_number
		# recorded_on
  end
end
