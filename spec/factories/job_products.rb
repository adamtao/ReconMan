# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job_product do
    product_id 1
    job_id 1
    price ""
    workflow_state "MyString"
  end
end
