json.array!(@branches) do |branch|
  json.extract! branch, :id, :name, :address, :city, :state_id, :zipcode, :phone, :client_id
  json.url branch_url(branch, format: :json)
end
