# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:name) {|n| "Product #{n}"}
    description "MyText"
    price_cents 1995
    performs_search false
    job_type { Job.job_types.sample.to_s }
    factory :tracking_product do
      job_type 'tracking'
      performs_search true
    end
    factory :search_product do
      job_type 'search'
      performs_search true
    end
    factory :special_product do
      job_type 'special'
      performs_search false
    end
  end

  factory :job_product do
    product
    job
    price_cents 1995
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
    factory :tracking_job_product do
      product { FactoryGirl.create(:tracking_product) }
      lender
    end
    factory :search_job_product do
      product { FactoryGirl.create(:search_product) }
    end
    factory :special_job_product do
      product { FactoryGirl.create(:special_product) }
    end
  end
end
