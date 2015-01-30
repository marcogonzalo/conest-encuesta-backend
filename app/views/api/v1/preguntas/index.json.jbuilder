json.array!(@preguntas) do |pregunta|
  json.extract! pregunta, :id, :interrogante, :descripcion, :tipo_pregunta_id
  json.url api_v1_pregunta_url(pregunta, format: :json)
end
