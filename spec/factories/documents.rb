# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    job_product
    file_file_name "filename.pdf"
    file_file_size 11111
    file_updated_at 2.days.ago
    file_content_type "application/pdf"
  end
end
