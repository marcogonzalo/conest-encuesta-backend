json.array!(@carreras) do |carrera|
  json.extract! carrera, :id, :codigo, :nombre, :organizacion_id
  json.url api_v1_carrera_url(carrera, format: :json)
end
