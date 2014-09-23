# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    message "MyText"
    user
    related_id 1
    related_type "MyString"
  end
end
