json.array!(@subjects) do |subject|
  json.extract! subject, :id, :name, :description, :rating_id
  json.url subject_url(subject, format: :json)
end
