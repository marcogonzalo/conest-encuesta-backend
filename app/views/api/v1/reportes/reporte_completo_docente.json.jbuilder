json.docente do
	json.extract! @docente, :cedula, :nombre_completo
end

unless @periodo_academico.nil?
	json.periodo @periodo_academico.periodo
end

json.instrumento do
	json.extract! @instrumento, :id, :nombre

	json.bloques @instrumento.bloques do |b|
		json.id b.id
		json.nombre b.nombre
		json.descripcion b.descripcion
		json.tipo b.tipo
		json.preguntas b.preguntas do |p|
			json.id p.id
			json.interrogante p.interrogante
			json.descripcion p.descripcion
			json.tipo_pregunta do |tp|
				json.extract! tp,  :nombre, :valor, :valor_html
			end
			json.opciones p.opciones do |o| 
				json.id o.id
				json.etiqueta o.etiqueta
				json.valor o.valor
			end

			json.resultados @resultados[p.id] do |periodo,materias|
				json.periodo periodo
				json.materias materias do |m,secciones|
					json.materia m
					json.secciones secciones do |s,info|
						json.seccion s
						json.datos do
							info['datos'].each do |clave, valor|
								json.set! clave, valor
							end
						end
						json.totalizacion info['totalizacion'] do |val, total|
							json.valor val
							json.total total
						end
					end
				end
			end
		end
	end
end