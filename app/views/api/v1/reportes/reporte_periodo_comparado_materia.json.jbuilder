unless @periodo_academico.nil?
	json.periodo @periodo_academico.periodo
end

json.materia do
	json.extract! @materia, :codigo, :nombre
end

json.instrumento do
	json.extract! @instrumento, :id, :nombre

	json.preguntas @preguntas do |p|
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

		json.resultados @resultados[p.id] do |periodo,secciones|
			json.periodo periodo
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