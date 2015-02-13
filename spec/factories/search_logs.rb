# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_log do
    task
    user
    status "Not Cleared"
  end
end
