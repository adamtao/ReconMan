# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job do
    sequence(:file_number) {|n| "#{n}"}
    client
    address "MyString"
    city "MyString"
    state
    zipcode "MyString"
    county
    association :requestor, factory: :user, role: 'client'
    old_owner "Old Owner"
    new_owner "New Owner"
    # close_on
    # underwriter_name
    # short_sale
    # file_type
    # association :creator, factory: :user
    # association :modifier, factory: :user
    job_type 'tracking'
  end
end
