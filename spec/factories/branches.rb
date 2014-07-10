# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :branch do
    name "MyString"
    address "MyString"
    city "MyString"
    state_id 1
    zipcode "MyString"
    phone "MyString"
    client_id 1
  end
end
