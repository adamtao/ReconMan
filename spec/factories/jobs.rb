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
    factory :tracking_job do
      job_type 'tracking'
      after(:create) do |job|
        FactoryGirl.create(:tracking_task, job: job)
      end
    end
    factory :search_job do
      job_type 'search'
      after(:create) do |job|
        FactoryGirl.create(:search_task, job: job)
      end
    end
    factory :special_job do
      job_type 'special'
      after(:create) do |job|
        FactoryGirl.create(:special_task, job: job)
      end
    end
    factory :documentation_job do
      job_type 'documentation'
      after(:create) do |job|
        FactoryGirl.create(:documentation_task, job: job)
      end
    end
  end
end
