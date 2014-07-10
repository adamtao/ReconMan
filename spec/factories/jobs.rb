# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job do
    name "MyString"
    client_id 1
    address "MyString"
    city "MyString"
    state_id 1
    zipcode "MyString"
    county_id 1
    last_search_at "2014-07-08 12:49:49"
    completed_at "2014-07-08 12:49:49"
    old_owner "MyString"
    new_owner "MyString"
    workflow_state "MyString"
    requestor_id 1
  end
end
