class ReportePeriodo
	# Procesa y genera el arreglo de resultados para una materia especificada del período académico en cada pregunta recibida
	def self.materia_periodo(oferta_periodo,preguntas)
		resultados ||= {}
		# Se recorre el arreglo de preguntas
		preguntas.each do |pregunta|
			resultados[pregunta.id] = {}
			resultados[pregunta.id] = ReportePeriodo.resultados_pregunta_materia(pregunta,oferta_periodo)
		end
		return resultados
	end

	# Procesa y genera el arreglo de resultados para un docente especificado del período académico en cada pregunta recibida
	def self.docente_periodo(ofertas_academicas,preguntas)
		resultados ||= {}
		# Se recorre el arreglo de preguntas
		preguntas.each do |pregunta|
			resultados[pregunta.id] = {}
			resultados[pregunta.id] = ReportePeriodo.resultados_pregunta_docente(pregunta,ofertas_academicas)
		end
		return resultados
	end

	# Procesa los resultados almacenados para una materia en una pregunta
	def self.resultados_pregunta_materia(pregunta,oferta_periodo)
		# Se obtienen las respuestas y se totalizan agrupadas por período y valor de respuesta
		respuestas = Respuesta.includes(consulta: { oferta_academica: { oferta_periodo: [:periodo_academico, :materia] } })
								.where(ofertas_periodo: { id: oferta_periodo.id }, respuestas: { pregunta_id: pregunta.id })
								.references(:ofertas_periodo)
								.group("periodos_academicos.periodo", "oferta_academica.nombre_seccion", "respuestas.valor")
								.order('oferta_academica.nombre_seccion ASC')
								.count
		aux_periodo = nil
		aux_seccion = nil
		total_respuestas = 0
		total_puntos = 0
		media_de_seccion = 0
		opciones = pregunta.opciones.order(:valor)

		# Para cada resultado {[periodo, seccion, valor] => total} de la materia
		resultados = respuestas.each_with_object({}) do |((periodo, seccion, valor), total), r|
			puts respuestas
			puts "Verificacion de que periodo es distinto"
			puts (aux_periodo != periodo)
			if aux_periodo != periodo
				r[periodo] ||= {}
				aux_periodo = periodo
				aux_seccion = nil
			end

			puts "Verificacion de que seccion es distinta"
			puts (aux_seccion != seccion)
			if aux_seccion != seccion
				total_respuestas = 0
				total_puntos = 0
				media_de_seccion = 0
				r[periodo][seccion] ||= {}
				r[periodo][seccion]['datos'] ||= {}
				r[periodo][seccion]['totalizacion'] ||= {}

				# Inicializacion de totalizacion de valores
				opciones.each do |o|
					r[periodo][seccion]['totalizacion'][o.valor] = 0
				end

				# Se obtiene el total de estudiantes de esa sección en ese período
				oferta_academica = oferta_periodo.oferta_academica.where(oferta_academica: { nombre_seccion: seccion}).first
				r[periodo][seccion]['datos']['total_estudiantes'] = oferta_academica.nro_estudiantes
				aux_seccion = seccion
			end
			
			# Asignacion de totalizacion a valor
			r[periodo][seccion]['totalizacion'][valor] = total
			
			total_respuestas += total
			r[periodo][seccion]['datos']['total_respuestas'] = total_respuestas

			total_puntos += (valor*total).to_f
			media_de_seccion = (total_puntos/total_respuestas.to_f).to_f
			r[periodo][seccion]['datos']['media_de_seccion'] = media_de_seccion
		end
		return resultados
	end

	# Procesa los resultados almacenados para un docente en una pregunta
	def self.resultados_pregunta_docente(pregunta,ofertas_academicas)
		# Se obtienen las respuestas y se totalizan agrupadas por período y valor de respuesta
		respuestas = Respuesta.includes(consulta: { oferta_academica: { oferta_periodo: [:periodo_academico, :materia] } })
								.where(oferta_academica: { id: ofertas_academicas }, respuestas: { pregunta_id: pregunta.id })
								.references(:oferta_academica)
								.group("periodos_academicos.periodo", "materias.codigo", "oferta_academica.nombre_seccion", "respuestas.valor")
								.order('count_id ASC')
								.count
		aux_periodo = nil
		aux_materia = nil
		aux_seccion = nil
		total_respuestas = 0
		total_puntos = 0
		media_de_seccion = 0
		opciones = pregunta.opciones.order(:valor)
		
		# Para cada resultado {[periodo, materia, seccion, valor] => total} de la materia
		resultados = respuestas.each_with_object({}) do |((periodo, materia, seccion, valor), total), r|

			# Verificacion de que periodo es distinto"
			puts (aux_periodo != periodo)
			if aux_periodo != periodo
				r[periodo] ||= {}
				aux_periodo = periodo
				aux_materia = nil
			end


			# Verificacion de que materia es distinta"
			puts (aux_materia != materia)
			if aux_materia != materia
				r[periodo][materia] ||= {}
				aux_materia = materia
				aux_seccion = nil
			end

			# Verificacion de que seccion es distinta"
			if aux_seccion != seccion
				total_respuestas = 0
				total_puntos = 0
				media_de_seccion = 0
				r[periodo][materia][seccion] ||= {}
				r[periodo][materia][seccion]['datos'] ||= {}
				r[periodo][materia][seccion]['totalizacion'] ||= {}

				# Inicializacion de totalizacion de valores
				opciones.each do |o|
					r[periodo][materia][seccion]['totalizacion'][o.valor] = 0
				end

				# Se obtiene el total de estudiantes de esa sección en ese período
				oferta_academica = ofertas_academicas.where(oferta_academica: { nombre_seccion: seccion}).first
				r[periodo][materia][seccion]['datos']['total_estudiantes'] = oferta_academica.nro_estudiantes
				aux_seccion = seccion
			end

			# Asignacion de totalizacion a valor
			r[periodo][materia][seccion]['totalizacion'][valor] = total

			total_respuestas += total
			r[periodo][materia][seccion]['datos']['total_respuestas'] = total_respuestas

			total_puntos += (valor*total).to_f
			media_de_seccion = (total_puntos/total_respuestas.to_f).to_f
			r[periodo][materia][seccion]['datos']['media_de_seccion'] = media_de_seccion
		end
		return resultados
	end
end
