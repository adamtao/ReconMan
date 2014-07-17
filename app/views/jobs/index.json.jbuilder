json.array!(@jobs) do |job|
  json.extract! job, :id, :name, :client_id, :address, :city, :state_id, :zipcode, :county_id, :completed_at, :old_owner, :new_owner, :workflow_state, :requestor_id
  json.url job_url(job, format: :json)
end
