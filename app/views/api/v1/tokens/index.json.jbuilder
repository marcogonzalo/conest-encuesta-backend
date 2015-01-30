json.array!(@tokens) do |token|
  json.extract! token, :id, :token, :hash_sum
  json.url api_v1_token_url(token, format: :json)
end
