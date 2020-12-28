FactoryBot.define do
  factory :comment do
    message { "MyText" }
    user
    related_id { 1 }
    related_type { "MyString" }
  end
end
