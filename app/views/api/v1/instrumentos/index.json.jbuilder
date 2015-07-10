json.array!(@instrumentos) do |instrumento|
  json.extract! instrumento, :id, :nombre, :descripcion, :updated_at
  json.url api_v1_instrumento_url(instrumento, format: :json)
end
