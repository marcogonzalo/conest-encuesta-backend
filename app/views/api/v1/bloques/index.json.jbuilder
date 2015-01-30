json.array!(@bloques) do |bloque|
  json.extract! bloque, :id, :nombre, :descripcion, :tipo
  json.url api_v1_bloque_url(bloque, format: :json)
end
