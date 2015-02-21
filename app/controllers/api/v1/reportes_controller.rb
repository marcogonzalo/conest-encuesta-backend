module Api
  module V1
    class ReportesController < ApplicationController
    	def controlador
    		case params[:tipo_reporte] 
	    		when 'sencillo'
	    			reporte_sencillo
	    		when 'comparado'
	    			reporte_comparado
	    		else
	    			reporte_sencillo
    		end
    	end

		protected
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
		    			if @pregunta.bloques.find_by(tipo: 'D').nil?
		    			# Si es una pregunta sobre la materia
		    				puts "De la materia"

		    				# Se obtienen las respuestas y se totalizan agrupadas por período y valor de respuesta
		    				respuestas = Respuesta.includes(consulta: { oferta_academica: { oferta_periodo: [:periodo_academico, :materia] } })
													.where(materias: { codigo: @materia.codigo }, respuestas: { pregunta_id: @pregunta.id	})
													.references(:materias)
													.group("periodos_academicos.periodo", "oferta_academica.nombre_seccion", "respuestas.valor")
													.order('count_id ASC')
													.count
		    				puts respuestas.inspect
		    				aux_periodo = ""
		    				aux_seccion = ""
		    				total_respuestas = 0
								# Para cada resultado {[periodo, seccion, valor] => total} de la materia
		    				@resultados = respuestas.each_with_object({}) do |((periodo, seccion, valor), total), r|
		    					puts "periodo"+periodo
		    					puts "seccion"+seccion
		    					puts "valor"+valor.to_s
		    					puts "total"+total.to_s
								if aux_periodo != periodo
									aux_periodo = periodo
				    				aux_seccion = ""
									r[periodo] ||= {}
								end

								if aux_seccion != seccion
									puts "aux_seccion"+aux_seccion
									total_respuestas = 0
									r[periodo][seccion] ||= {}
									r[periodo][seccion]["datos"] ||= {}
									r[periodo][seccion]["totalizacion"] ||= {}

									# Se obtiene el total de estudiantes de esa sección en ese período
									oferta_academica = OfertaAcademica.includes(oferta_periodo: [:periodo_academico, :materia])
																		.where(oferta_academica: { nombre_seccion: seccion},
																				materias: { codigo: @materia.codigo }, 
																				periodos_academicos: { periodo: periodo})
																		.references(:materias).first
									r[periodo][seccion]["datos"]["total_estudiantes"] = oferta_academica.nro_estudiantes
									aux_seccion = seccion
								end
								r[periodo][seccion]["totalizacion"][valor] = total

								puts "respuestas"+total_respuestas.to_s
								total_respuestas = total_respuestas + total
								puts "respuestas"+total_respuestas.to_s
								r[periodo][seccion]["datos"]["total_respuestas"] = total_respuestas
							end
							puts @resultados.inspect
		    			else
		    			# Si es una pregunta sobre el profesor, es decir, la sección
		    				puts "De la sección o el docente"
		    			end
		    		end

	    			#puts @pregunta.attributes
	    			respond_to do |format|
				        if error.nil?
							format.json { render :reporte_sencillo, status: :ok }
							format.pdf do
								pdf = ReporteSencilloPdfGenerator.new(@materia,@pregunta,@resultados) #Prawn::Document.new
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
    end
  end
end
