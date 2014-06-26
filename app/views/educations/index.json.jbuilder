json.array!(@educations) do |education|
  json.extract! education, :id, :founder_id, :school
  json.url education_url(education, format: :json)
end
