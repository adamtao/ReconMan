json.array!(@counties) do |county|
  json.extract! county, :id, :name, :state, :search_url, :search_params, :search_method, :average_days_to_complete
  json.url county_url(county, format: :json)
end
