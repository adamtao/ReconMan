# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job do
    parcel_number "MyString"
    client
    address "MyString"
    city "MyString"
    state
    zipcode "MyString"
    county
    new_owner "MyString"
    requestor
  end
end
