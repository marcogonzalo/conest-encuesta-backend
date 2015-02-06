json.extract! @instrumento, :id, :nombre, :descripcion, :created_at, :updated_at
json.bloques @instrumento.bloques do |b|
	json.id b.id
	json.nombre b.nombre
	json.descripcion b.descripcion
	json.tipo b.tipo
	json.preguntas b.preguntas do |p|
		json.id p.id
		json.interrogante p.interrogante
		json.descripcion p.descripcion
		json.tipo_pregunta_id p.tipo_pregunta_id
		json.opciones p.opciones do |o| 
			json.id o.id
			json.etiqueta o.etiqueta
			json.valor o.valor
		end
	end	
end
