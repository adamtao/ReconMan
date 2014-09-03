# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :branch do
    name "MyString"
    address "MyString"
    city "MyString"
    state
    zipcode "MyString"
    phone "MyString"
    client
  end
end
