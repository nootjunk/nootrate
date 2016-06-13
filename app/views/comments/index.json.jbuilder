json.array!(@rating_comments) do |comment|
  json.extract! comment, :id, :description, :rating_id
  json.url rating_comment_url(comment, format: :json)
end
