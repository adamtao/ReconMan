# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :title_search_cach, :class => 'TitleSearchCache' do
    job_product_id 1
    content "MyText"
  end
end
