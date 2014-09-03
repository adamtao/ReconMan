# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :zipcode do
    zipcode "MyString"
    zip_type "MyString"
    primary_city "MyString"
    acceptable_cities "MyText"
    unacceptable_cities "MyText"
    state "MyString"
    county "MyString"
    timezone "MyString"
    area_codes "MyText"
    latitude 1.5
    longitude 1.5
    world_region "MyString"
    country "MyString"
    decommissioned false
    estimated_population 1
    notes "MyText"
  end
end
