json.array!(@opciones) do |opcion|
  json.extract! opcion, :id, :etiqueta, :valor, :pregunta_id
  json.url api_v1_pregunta_opcion_url(opcion.pregunta_id, opcion, format: :json)
end
