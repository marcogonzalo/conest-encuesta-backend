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
		    				respuestas = Respuesta.includes(consulta: { oferta_academica: { oferta_periodo: [:periodo_academico, :materia] } })
		    																.where(materias: { codigo: @materia.codigo }, respuestas: { pregunta_id: @pregunta.id	})
		    																.references(:materias)
		    																.group("periodos_academicos.periodo", "respuestas.valor")
		    																.order('count_id ASC')
		    																.count
		    				puts respuestas.inspect
		    				aux_periodo = 0
		    				@resultados = respuestas.each_with_object({}) do |((periodo, valor), total), r|
								  if aux_periodo != periodo
									  total_respuestas = 0
									  aux_periodo = periodo
									  r[periodo] ||= {}
									  r[periodo]["totalizacion"] ||= {}
									  r[periodo]["datos"] ||= {}
									  r[periodo]["datos"]["total_estudiantes"] = OfertaAcademica.includes(oferta_periodo: [:periodo_academico, :materia])
																						    																.where(materias: { codigo: @materia.codigo }, periodos_academicos: { periodo: periodo})
																						    																.references(:materias)
																						    																.sum("nro_estudiantes")
									end


								  r[periodo]["totalizacion"][valor] = total

								  total_respuestas = total_respuestas + total
								  r[periodo]["datos"]["total_respuestas"] = total_respuestas
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