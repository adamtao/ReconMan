# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :branch do
    sequence(:name) {|b| "Branch ##{b}"}
    address "MyString"
    city "MyString"
    state
    zipcode "MyString"
    phone "MyString"
    client
  end
end
