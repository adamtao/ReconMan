FactoryBot.define do
  factory :branch do
    sequence(:name) {|b| "Branch ##{b}"}
    address { "MyString" }
    city { "MyString" }
    state
    zipcode { "MyString" }
    phone { "MyString" }
    client
  end
end
