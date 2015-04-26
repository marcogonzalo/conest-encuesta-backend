json.materia do
	json.extract! @materia, :codigo, :nombre
end

json.pregunta do
	json.extract! @pregunta, :id, :interrogante
end

@resultados.each do |pregunta_id,periodos|
	json.periodos periodos do |p, secciones|
		json.periodo p
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
