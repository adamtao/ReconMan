# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:name) {|n| "Product #{n}"}
    description "MyText"
    price_cents 1995
    performs_search false
    job_type { Job.job_types.sample.to_s }
  end
end
