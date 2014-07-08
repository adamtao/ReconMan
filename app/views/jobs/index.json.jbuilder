json.array!(@jobs) do |job|
  json.extract! job, :id, :name, :client_id, :address, :city, :state, :zipcode, :county_id, :last_search_at, :completed_at, :old_owner, :new_owner, :workflow_state
  json.url job_url(job, format: :json)
end
