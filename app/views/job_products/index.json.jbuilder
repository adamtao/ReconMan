json.array!(@job_products) do |job_product|
  json.extract! job_product, :id, :product_id, :job_id, :price, :workflow_state
  json.url job_product_url(job_product, format: :json)
end
