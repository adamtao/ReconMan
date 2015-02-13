json.array!(@tasks) do |task|
  json.extract! task, :id, :product_id, :job_id, :price, :workflow_state
  json.url task_url(task, format: :json)
end
