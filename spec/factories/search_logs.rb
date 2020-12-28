FactoryBot.define do
  factory :search_log do
    task
    user
    status { "Not Cleared" }
  end
end
