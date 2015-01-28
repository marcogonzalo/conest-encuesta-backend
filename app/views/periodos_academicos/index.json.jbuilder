json.array!(@periodos_academicos) do |periodo_academico|
  json.extract! periodo_academico, :id, :periodo, :hash_sum, :sincronizacion
  json.url periodo_academico_url(periodo_academico, format: :json)
end
