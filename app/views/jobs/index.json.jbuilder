json.array!(@jobs) do |job|
  json.extract! job, :id, :founder_id, :position, :company, :company_description
  json.url job_url(job, format: :json)
end
