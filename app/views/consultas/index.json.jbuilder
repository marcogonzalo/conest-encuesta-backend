json.array!(@consultas) do |consulta|
  json.extract! consulta, :id, :oferta_academica_id, :instrumento_id
  json.url consulta_url(consulta, format: :json)
end
