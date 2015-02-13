# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :title_search_cach, :class => 'TitleSearchCache' do
    task
    content "MyText"
  end
end
