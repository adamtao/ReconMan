json.array!(@client_products) do |client_product|
  json.extract! client_product, :id, :product_id, :client_id, :price
  json.url client_client_product_url(@client, client_product, format: :json)
end
