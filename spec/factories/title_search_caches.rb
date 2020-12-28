FactoryBot.define do
  factory :title_search_cach, :class => 'TitleSearchCache' do
    task
    content { "MyText" }
  end
end
