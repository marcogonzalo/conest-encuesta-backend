json.extract! @consulta, :id, :instrumento_id, :created_at, :updated_at

json.oferta_academica do
	json.periodo @consulta.oferta_academica.oferta_periodo.periodo_academico.periodo
	json.seccion @consulta.oferta_academica.nombre_seccion
	json.extract! @consulta.oferta_academica.oferta_periodo.materia, :nombre, :codigo
	json.docente do
		json.extract! @consulta.oferta_academica.docente, :primer_nombre, :primer_apellido
	end
end