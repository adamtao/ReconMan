# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_product do
    client
    product
    price_cents 1995
  end
end
