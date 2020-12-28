FactoryBot.define do
  factory :zipcode do
    zipcode { Forgery::Address.zip }
    zip_type { "MyString" }
    primary_city { Forgery::Address.city }
    acceptable_cities { "MyText" }
    unacceptable_cities { "BadCity" }
    state { "MyString" }
    county { "MyString" }
    timezone { "MyString" }
    area_codes { "MyText" }
    latitude { 1.5 }
    longitude { 1.5 }
    world_region { "MyString" }
    country { "US" }
    decommissioned { false }
    estimated_population { 10000 }
    notes { "MyText" }
  end
end
