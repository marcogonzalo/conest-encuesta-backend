class ReportePeriodo
	def self.materia_periodo(oferta_periodo,preguntas)
		resultados ||= {}
		preguntas.each do |pregunta|
			resultados[pregunta.id] = {}
			resultados[pregunta.id] = ReportePeriodo.resultados_pregunta_materia(pregunta,oferta_periodo)
		end
		return resultados
	end

	def self.docente_periodo(ofertas_academicas,preguntas)
		resultados ||= {}
		preguntas.each do |pregunta|
			resultados[pregunta.id] = {}
			resultados[pregunta.id] = ReportePeriodo.resultados_pregunta_docente(pregunta,ofertas_academicas)
		end
		return resultados
	end

	def self.resultados_pregunta_materia(pregunta,oferta_periodo)
		# Se obtienen las respuestas y se totalizan agrupadas por período y valor de respuesta
		respuestas = Respuesta.includes(consulta: { oferta_academica: { oferta_periodo: [:periodo_academico, :materia] } })
								.where(ofertas_periodo: { id: oferta_periodo.id }, respuestas: { pregunta_id: pregunta.id })
								.references(:ofertas_periodo)
								.group("periodos_academicos.periodo", "oferta_academica.nombre_seccion", "respuestas.valor")
								.order('count_id ASC')
								.count
		aux_periodo = ""
		aux_seccion = ""
		total_respuestas = 0
		opciones = pregunta.opciones.order(:valor)

		# Para cada resultado {[periodo, seccion, valor] => total} de la materia
		resultados = respuestas.each_with_object({}) do |((periodo, seccion, valor), total), r|
			if aux_periodo != periodo
				aux_periodo = periodo
				aux_seccion = ""
				r[periodo] ||= {}
			end

			if aux_seccion != seccion
				total_respuestas = 0
				r[periodo][seccion] ||= {}
				r[periodo][seccion]['datos'] ||= {}
				r[periodo][seccion]['totalizacion'] ||= {}
				opciones.each do |o|
					r[periodo][seccion]['totalizacion'][o.valor] = 0
				end

				# Se obtiene el total de estudiantes de esa sección en ese período
				oferta_academica = oferta_periodo.oferta_academica.where(oferta_academica: { nombre_seccion: seccion}).first
				r[periodo][seccion]['datos']['total_estudiantes'] = oferta_academica.nro_estudiantes
				aux_seccion = seccion
			end
			r[periodo][seccion]['totalizacion'][valor] = total

			total_respuestas += total
			r[periodo][seccion]['datos']['total_respuestas'] = total_respuestas
		end
		return resultados
	end

	def self.resultados_pregunta_docente(pregunta,ofertas_academicas)
		# Se obtienen las respuestas y se totalizan agrupadas por período y valor de respuesta
		respuestas = Respuesta.includes(consulta: { oferta_academica: { oferta_periodo: [:periodo_academico, :materia] } })
								.where(oferta_academica: { id: ofertas_academicas }, respuestas: { pregunta_id: pregunta.id })
								.references(:oferta_academica)
								.group("periodos_academicos.periodo", "materias.codigo", "oferta_academica.nombre_seccion", "respuestas.valor")
								.order('count_id ASC')
								.count
		aux_periodo = ""
		aux_seccion = ""
		total_respuestas = 0
		opciones = pregunta.opciones.order(:valor)

		# Para cada resultado {[periodo, materia, seccion, valor] => total} de la materia
		resultados = respuestas.each_with_object({}) do |((periodo, materia, seccion, valor), total), r|
			if aux_periodo != periodo
				aux_periodo = periodo
				aux_materia = ""
				r[periodo] ||= {}
			end

			if aux_materia != materia
				aux_materia = materia
				aux_seccion = ""
				r[periodo][materia] ||= {}
			end

			if aux_seccion != seccion
				total_respuestas = 0
				r[periodo][materia][seccion] ||= {}
				r[periodo][materia][seccion]['datos'] ||= {}
				r[periodo][materia][seccion]['totalizacion'] ||= {}
				opciones.each do |o|
					r[periodo][materia][seccion]['totalizacion'][o.valor] = 0
				end

				# Se obtiene el total de estudiantes de esa sección en ese período
				oferta_academica = ofertas_academicas.where(oferta_academica: { nombre_seccion: seccion}).first
				r[periodo][materia][seccion]['datos']['total_estudiantes'] = oferta_academica.nro_estudiantes
				aux_seccion = seccion
			end
			r[periodo][materia][seccion]['totalizacion'][valor] = total

			total_respuestas += total
			r[periodo][materia][seccion]['datos']['total_respuestas'] = total_respuestas
		end
		return resultados
	end
end
