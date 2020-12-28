FactoryBot.define do
  factory :client_product do
    client
    product
    price_cents { 1995 }
  end
end
