json.array!(@tokens) do |token|
  json.extract! token, :id, :token, :hash_sum
  json.url token_url(token, format: :json)
end
