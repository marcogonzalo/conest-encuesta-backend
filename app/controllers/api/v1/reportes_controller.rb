module Api
	module V1
		class ReportesController < ApplicationController
			def reporte_sencillo
				error = nil
				@pregunta = Pregunta.find(params[:pregunta_id])
				@materia = Materia.find_by(codigo: params[:codigo_materia])
				if @materia.nil?
					error = :no_materia
				else
					if @pregunta.nil?
						error = :no_pregunta
					else
						@resultados = resultados_historicos_pregunta(@pregunta,@materia)
					end

					#puts @pregunta.attributes
					respond_to do |format|
				        if error.nil?
							format.json { render :reporte_sencillo, status: :ok }
							format.pdf do
								pdf = ReporteSencilloPdf.new(@materia,@pregunta,@resultados) #Prawn::Document.new
								send_data pdf.render, filename: 'reporte-consulta.pdf'
							end
						elsif error == :no_materia	
							render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
						elsif error == :no_pregunta	
							render json: { estatus: "ERROR", mensaje: "La pregunta no está registrada" }, status: :not_found
						end
					end
				end
			end

			def reporte_comparado
			end

			def reporte_completo
			end

			def reporte_historico
				error = nil
				@instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:instrumento_id])
				@materia = Materia.find_by(codigo: params[:codigo_materia])
				if @instrumento.nil?
					error = :no_instrumento
				else
					if @materia.nil?
						error = :no_materia
					else
						@resultados ||= {}
						@instrumento.bloques.each do |bloque|
							bloque.preguntas.each do |pregunta|
								@resultados[pregunta.id] = {}
								@resultados[pregunta.id] = resultados_historicos_pregunta(pregunta,@materia)
							end
						end
					end

					puts @resultados.inspect
					respond_to do |format|
				        if error.nil?
							format.json { render :reporte_historico, status: :ok }
							format.pdf do
								pdf = ReporteHistoricoPdf.new(@materia,@instrumento,@resultados) #Prawn::Document.new
								send_data pdf.render, filename: 'reporte-consulta.pdf'
							end
						elsif error == :no_materia	
							render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
						elsif error == :no_instrumento	
							render json: { estatus: "ERROR", mensaje: "El instrumento no existe" }, status: :not_found
						end
					end
				end
			end

			protected
			def resultados_historicos_pregunta(pregunta,materia)
				if pregunta.bloques.find_by(tipo: 'D')
				# Si es una pregunta sobre el profesor, es decir, la sección
					puts "De la sección o el docente"
				else
				# Si es una pregunta sobre la materia
					puts "De la materia"
					puts pregunta.inspect
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
		end
	end
end
