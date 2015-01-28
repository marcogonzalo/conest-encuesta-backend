json.array!(@bloques) do |bloque|
  json.extract! bloque, :id, :nombre, :descripcion, :tipo
  json.url bloque_url(bloque, format: :json)
end
