json.array!(@ofertas_periodo) do |oferta_periodo|
  json.extract! oferta_periodo, :id, :materia, :docente_coordinador
  json.instrumento_de_consulta oferta_periodo.oferta_academica.first.consulta.instrumento  
end
