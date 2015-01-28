json.array!(@carreras) do |carrera|
  json.extract! carrera, :id, :codigo, :nombre, :organizacion_id
  json.url carrera_url(carrera, format: :json)
end
