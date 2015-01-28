json.array!(@respuestas) do |respuesta|
  json.extract! respuesta, :id, :consulta_id, :pregunta_id, :valor
  json.url respuesta_url(respuesta, format: :json)
end
