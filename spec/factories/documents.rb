# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    job_product_id 1
    file_file_name "MyString"
    file_file_size 1
    file_updated_at "2014-10-18 13:10:55"
    file_content_type "MyString"
  end
end
