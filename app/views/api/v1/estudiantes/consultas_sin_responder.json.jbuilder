json.estudiante_id @estudiante.id
json.consultas_sin_responder @consultas_sin_responder do |c|
	json.id c.id
	json.nombre_seccion c.nombre_seccion
	json.materia do
		json.extract! c.oferta_periodo.materia, :id, :codigo, :nombre, :tipo_materia_id
	end
	json.periodo_academico c.oferta_periodo.periodo_academico.periodo
end
