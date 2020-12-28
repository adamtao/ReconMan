FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "Test User #{n}"}
    sequence(:email) {|n| "user#{n}@example.com"}
    password { "please123" }

    trait :admin do
      role { 'admin' }
    end

    trait :client do
    	role { 'client' }
      branch
    end

    trait :processor do
      role { 'processor' }
    end

  end
end
