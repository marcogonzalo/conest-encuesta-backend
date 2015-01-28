json.array!(@preguntas) do |pregunta|
  json.extract! pregunta, :id, :interrogante, :descripcion, :tipo_pregunta_id
  json.url pregunta_url(pregunta, format: :json)
end
