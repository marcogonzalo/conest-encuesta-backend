json.array!(@instrumentos) do |instrumento|
  json.extract! instrumento, :id, :nombre, :descripcion
  json.url instrumento_url(instrumento, format: :json)
end
