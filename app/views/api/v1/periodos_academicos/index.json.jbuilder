json.array!(@periodos_academicos) do |periodo_academico|
  json.extract! periodo_academico, :id, :periodo, :asignaturas_hash_sum, :sincronizacion
  json.url api_v1_periodo_academico_url(periodo_academico, format: :json)
end
