json.array!(@tipos_pregunta) do |tipo_pregunta|
  json.extract! tipo_pregunta, :id, :nombre, :valor, :valor_html
  json.url api_v1_tipo_pregunta_url(tipo_pregunta, format: :json)
end
