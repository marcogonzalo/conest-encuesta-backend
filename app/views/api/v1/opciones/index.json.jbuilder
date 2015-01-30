json.array!(@opciones) do |opcion|
  json.extract! opcion, :id, :etiqueta, :valor, :pregunta_id
  json.url api_v1_opcion_url(opcion, format: :json)
end
