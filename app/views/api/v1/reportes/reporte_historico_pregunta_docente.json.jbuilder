json.docente do
	json.extract! @docente, :cedula, :nombre_completo
end

json.pregunta do
	json.extract! @pregunta, :id, :interrogante
end

@resultados.each do |k,periodos|
	json.periodos periodos do |p, materias|
		json.periodo p
		json.materias materias do |m, secciones|
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
