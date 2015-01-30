json.array!(@ofertas_periodo) do |oferta_periodo|
  json.extract! oferta_periodo, :id, :materia_id, :periodo_academico_id, :docente_coordinador
  json.url api_v1_oferta_periodo_url(oferta_periodo, format: :json)
end
