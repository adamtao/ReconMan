# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "MyString"
    description "MyText"
    price_cents 1995
    performs_search false
    job_type 'tracking'
  end
end
