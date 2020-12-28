FactoryBot.define do
  factory :lender do
    sequence(:name){|n| "Lender #{n}"}
  end

end
