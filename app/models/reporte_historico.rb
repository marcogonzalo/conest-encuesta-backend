class ReporteHistorico
	def self.materia_preguntas(materia,preguntas)
		if materia.nil?
			error = :no_materia
			return nil
		else
			resultados ||= {}
			preguntas.each do |pregunta|
				resultados[pregunta.id] = {}
				resultados[pregunta.id] = ReporteHistorico.resultados_pregunta_materia(pregunta,materia)
			end
			return resultados
		end
	end

	def self.resultados_pregunta_materia(pregunta,materia)
		# Se obtienen las respuestas y se totalizan agrupadas por período y valor de respuesta
		respuestas = Respuesta.includes(consulta: { oferta_academica: { oferta_periodo: [:periodo_academico, :materia] } })
								.where(materias: { codigo: materia.codigo }, respuestas: { pregunta_id: pregunta.id	})
								.references(:materias)
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
				oferta_academica = OfertaAcademica.includes(oferta_periodo: [:periodo_academico, :materia])
													.where(oferta_academica: { nombre_seccion: seccion},
															materias: { codigo: materia.codigo }, 
															periodos_academicos: { periodo: periodo})
													.references(:materias).first
				r[periodo][seccion]['datos']['total_estudiantes'] = oferta_academica.nro_estudiantes
				aux_seccion = seccion
			end
			r[periodo][seccion]['totalizacion'][valor] = total

			total_respuestas += total
			r[periodo][seccion]['datos']['total_respuestas'] = total_respuestas
		end
		return resultados
	end
end