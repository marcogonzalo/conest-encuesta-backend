json.pregunta do
	json.extract! @pregunta, :id, :interrogante
end

json.materia do
	json.extract! @materia, :codigo, :nombre
end

json.periodos @resultados do |k,periodo,secciones|
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