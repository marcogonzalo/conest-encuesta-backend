require 'csv'
module Api
	module V1
		class ReportesController < ApplicationController
			######
			# => Reportes Históricos de Materias
			######

			# Devuelve todos los resultados históricos para una pregunta en una materia
			def reporte_historico_materia_pregunta
				error = nil
				@materia = Materia.find_by(codigo: params[:codigo_materia])
				if @materia.nil?
					error = :no_materia
				else
					@pregunta = Pregunta.find(params[:pregunta_id])
					if @pregunta.nil?
						error = :no_pregunta
					else
						@preguntas ||= []
						@preguntas.push(@pregunta)
						@resultados = ReporteHistorico.materia_preguntas(@materia,@preguntas)
					end
				end
				#puts @pregunta.attributes
				respond_to do |format|
			        if error.nil?
						format.json { render :reporte_historico_pregunta, status: :ok }
						format.pdf do
							pdf = ReporteHistoricoPreguntaPdf.new(@materia,@pregunta,@resultados) #Prawn::Document.new
							send_data pdf.render, filename: 'reporte-consulta.pdf'
						end
						format.csv do
							headers['Content-Disposition'] = "attachment; filename=\"reporte-consulta\""
							headers['Content-Type'] ||= 'text/csv; charset=UTF-8; header=present'
							render :reporte_historico_pregunta
						end
					elsif error == :no_materia	
						render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
					elsif error == :no_pregunta	
						render json: { estatus: "ERROR", mensaje: "La pregunta no está registrada" }, status: :not_found
					end
				end
			end

			# Devuelve todos los resultados de las preguntas especificadas de un instrumento en una materia
			def reporte_historico_materia_comparado
				error = nil
				if params[:ids].nil?
					error = :no_parameters
				else
					preguntas_ids = params[:ids]
					@instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:instrumento_id])
					if @instrumento.nil?
						error = :no_instrumento
					else
						@materia = Materia.find_by(codigo: params[:codigo_materia])
						@preguntas = @instrumento.preguntas.where(id: preguntas_ids)
						@resultados = ReporteHistorico.materia_preguntas(@materia,@preguntas)
					end
				end
				respond_to do |format|
			        if error.nil?
						format.json { render :reporte_historico_comparado, status: :ok }
					elsif error == :no_materia	
						render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
					elsif error == :no_parameters	
					puts error
						render json: { estatus: "ERROR", mensaje: "No se detectaron parámetros para la comparación" }.to_json, status: :ok
					end
				end
			end

			# Devuelve todos los resultados de las preguntas de un instrumento en una materia
			def reporte_historico_materia_completo
				error = nil
				@instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:instrumento_id])
				if @instrumento.nil?
					error = :no_instrumento
				else
					@materia = Materia.find_by(codigo: params[:codigo_materia])
					if @materia.nil?
						error = :no_materia
					else
						@preguntas ||= []
						@instrumento.bloques.each do |bloque|
							bloque.preguntas.each do |pregunta|
								@preguntas.push(pregunta)
							end
						end
						@resultados = ReporteHistorico.materia_preguntas(@materia,@preguntas)
					end
				end
				respond_to do |format|
					if error.nil?
						format.json { render :reporte_materia_completo, status: :ok }
						format.pdf do
							pdf = ReporteMateriaCompletoPdf.new(@materia,@instrumento,@resultados,"Reporte histórico") #Prawn::Document.new
							send_data pdf.render, filename: 'reporte-consulta.pdf'
						end
					elsif error == :no_materia	
						render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :ok
					elsif error == :no_instrumento	
						render json: { estatus: "ERROR", mensaje: "El instrumento no existe" }, status: :ok
					end
				end
			end

			######
			# => Reportes de Período por Materias
			######

			# Devuelve la totalización de resultados de cada sección para las preguntas del instrumento aplicado para el período en una materia
			def reporte_periodo_materia_completo
				error = nil
				@periodo_academico = PeriodoAcademico.find_by(periodo: params[:periodo])
				if @periodo_academico.nil?
					error = :no_instrumento
				else
					@materia = Materia.find_by(codigo: params[:codigo_materia])
					if @materia.nil?
						error = :no_materia
					else
						@oferta_periodo = OfertaPeriodo.includes(:periodo_academico, :materia, :docente_coordinador, [oferta_academica: :consulta]).find_by(materia: @materia, periodo_academico: @periodo_academico)
						if @oferta_periodo.nil?
							error = :no_oferta_periodo
							return nil
						else
							@preguntas ||= []
							@instrumento = @oferta_periodo.oferta_academica.first.consulta.instrumento
							@instrumento.bloques.each do |bloque|
								bloque.preguntas.each do |pregunta|
									@preguntas.push(pregunta)
								end
							end
							@resultados = ReportePeriodo.materia_periodo(@oferta_periodo,@preguntas)
						end
					end
				end
				respond_to do |format|
					if error.nil?
						format.json { render :reporte_materia_completo, status: :ok }
						format.pdf do
							pdf = ReporteMateriaCompletoPdf.new(@materia,@instrumento,@resultados,"Reporte Período #{@periodo_academico.periodo}") #Prawn::Document.new
							send_data pdf.render, filename: "reporte-completo-#{@materia.codigo}-periodo-#{@periodo_academico.periodo}.pdf"
						end
					elsif error == :no_materia	
						render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :ok
					elsif error == :no_instrumento	
						render json: { estatus: "ERROR", mensaje: "El instrumento no existe" }, status: :ok
					end
				end
			end

			# Devuelve los resultados las preguntas especificadas de instrumento aplicado para el período en una materia
			def reporte_periodo_materia_comparado
				error = nil

				if params[:ids].nil?
					error = :no_parameters
				else
					preguntas_ids = params[:ids]
					@periodo_academico = PeriodoAcademico.find_by(periodo: params[:periodo])
					if @periodo_academico.nil?
						error = :no_instrumento
					else
						@materia = Materia.find_by(codigo: params[:codigo_materia])
						if @materia.nil?
							error = :no_materia
						else
							@oferta_periodo = OfertaPeriodo.includes(:periodo_academico, :materia, :docente_coordinador, [oferta_academica: :consulta]).find_by(materia: @materia, periodo_academico: @periodo_academico)
							if @oferta_periodo.nil?
								error = :no_oferta_periodo
								return nil
							else
								@instrumento = @oferta_periodo.oferta_academica.first.consulta.instrumento
								@preguntas = @instrumento.preguntas.where(id: preguntas_ids)
								@resultados = ReportePeriodo.materia_periodo(@oferta_periodo,@preguntas)
							end
						end
					end
				end
				respond_to do |format|
					if error.nil?
						format.json { render :reporte_materia_periodo_comparado, status: :ok }
					elsif error == :no_materia	
						render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :ok
					elsif error == :no_instrumento	
						render json: { estatus: "ERROR", mensaje: "El instrumento no existe" }, status: :ok
					end
				end
			end
		end
	end
end
