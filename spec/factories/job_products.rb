# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job_product do
    product
    job
    price_cents 1995
  end
end
