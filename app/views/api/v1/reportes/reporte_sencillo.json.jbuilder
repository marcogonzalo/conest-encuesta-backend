json.pregunta do |p|
	json.extract! @pregunta, :id, :interrogante
end

json.periodos @resultados do |periodo,info|
	json.periodo periodo
	json.totalizacion info['totalizacion'] do |val, total|
		json.valor val
		json.total total
	end
	json.datos info['datos'] do |clave, valor|
		json.set! clave, valor
	end
end
