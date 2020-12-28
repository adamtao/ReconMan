FactoryBot.define do
  factory :client do
    sequence(:name) {|c| "Client ##{c}"}
    factory :client_with_tracking_jobs do
      after(:create) do |client|
        create_list(:tracking_job, 5)
      end
    end
    factory :client_with_search_jobs do
      after(:create) do |client|
        create_list(:search_job, 5)
      end
    end
    factory :client_with_special_jobs do
      after(:create) do |client|
        create_list(:special_job, 5)
      end
    end
  end
end
