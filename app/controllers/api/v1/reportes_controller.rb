require 'csv'
module Api
	module V1
		class ReportesController < ApplicationController
			######
			# => Reportes Históricos de Materias
			######

			# Devuelve todos los resultados históricos para una pregunta en una materia
			def reporte_historico_pregunta_de_materia
				@error = nil
				@materia = Materia.find_by(codigo: params[:codigo_materia])
				if @materia.nil?
					@error = :no_materia
				else
					@pregunta = Pregunta.find(params[:pregunta_id])
					if @pregunta.nil?
						@error = :no_pregunta
					else
						@preguntas ||= []
						@preguntas.push(@pregunta)
						@resultados = ReporteHistorico.materia_preguntas(@materia,@preguntas)
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_pregunta
		    ensure
		        if @error.nil?	
					respond_to do |format|
						format.json { render :reporte_historico_pregunta_materia, status: :ok }
						format.pdf do
							pdf = ReporteHistoricoPreguntaPdf.new(@materia,@pregunta,@resultados) #Prawn::Document.new
							send_data pdf.render, filename: 'reporte-consulta.pdf'
						end
						format.csv do
							headers['Content-Disposition'] = "attachment; filename=\"reporte-consulta\""
							headers['Content-Type'] ||= 'text/csv; charset=UTF-8; header=present'
							render :reporte_historico_pregunta
						end
					end
				elsif @error == :no_materia	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
				elsif @error == :no_pregunta	
					render json: { estatus: "ERROR", mensaje: "La pregunta no está registrada" }, status: :not_found
				end
			end

			# Devuelve todos los resultados de las preguntas especificadas de un instrumento en una materia
			def reporte_historico_comparado_de_materia
				@error = nil
				if params[:ids].nil? or params[:ids].size == 0
					@error = :no_parameters
				else
					preguntas_ids = params[:ids]
					@materia = Materia.find_by(codigo: params[:codigo_materia])
					if @materia.nil?
						@error = :no_materia
					else
						@instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:instrumento_id])
						@preguntas = @instrumento.preguntas.where(id: preguntas_ids)
						if @preguntas.nil? or @preguntas.size == 0
							@error = :no_preguntas
						else
							@resultados = ReporteHistorico.materia_preguntas(@materia,@preguntas)
						end
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_instrumento
		    ensure
		        if @error.nil?
					respond_to do |format|
						format.json { render :reporte_historico_comparado_materia, status: :ok }
					end
				elsif @error == :no_materia	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada." }, status: :not_found
				elsif @error == :no_instrumento
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada." }, status: :not_found
				elsif @error == :no_preguntas	
					render json: { estatus: "ERROR", mensaje: "Ninguna de las preguntas indicadas fue encontrada en el instrumento." }, status: :not_found
				elsif @error == :no_parameters	
					render json: { estatus: "ERROR", mensaje: "No se detectaron parámetros para la comparación." }.to_json, status: :bad_request
				end
			end

			# Devuelve todos los resultados de las preguntas de un instrumento en una materia
			def reporte_historico_completo_de_materia
				@error = nil
				@instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:instrumento_id])
				if @instrumento.nil?
					@error = :no_instrumento
				else
					@materia = Materia.find_by(codigo: params[:codigo_materia])
					if @materia.nil?
						@error = :no_materia
					else
						@preguntas ||= []
						@instrumento.bloques.each do |bloque|
							bloque.preguntas.each do |pregunta|
								@preguntas.push(pregunta)
							end
						end
						if @preguntas.nil? or @preguntas.size == 0
							@error = :no_preguntas
						else
							@resultados = ReporteHistorico.materia_preguntas(@materia,@preguntas)
						end
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_instrumento
		    ensure
				if @error.nil?
					respond_to do |format|
						format.json { render :reporte_materia_completo, status: :ok }
						format.pdf do
							pdf = ReporteMateriaCompletoPdf.new(@materia,@instrumento,@resultados,"Reporte histórico") #Prawn::Document.new
							send_data pdf.render, filename: 'reporte-consulta.pdf'
						end
					end
				elsif @error == :no_materia	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
				elsif @error == :no_instrumento	
					render json: { estatus: "ERROR", mensaje: "El instrumento no existe" }, status: :not_found
				elsif @error == :no_preguntas	
					render json: { estatus: "ERROR", mensaje: "Ninguna de las preguntas indicadas fue encontrada en el instrumento." }, status: :not_found
				end
			end

			######
			# => Reportes de Período por Materias
			######

			# Devuelve los resultados las preguntas especificadas de instrumento aplicado para el período en una materia
			def reporte_periodo_comparado_de_materia
				@error = nil

				if params[:ids].nil?
					@error = :no_parameters
				else
					preguntas_ids = params[:ids]
					@periodo_academico = PeriodoAcademico.find_by(periodo: params[:periodo])
					if @periodo_academico.nil?
						@error = :no_periodo
					else
						@materia = Materia.find_by(codigo: params[:codigo_materia])
						if @materia.nil?
							@error = :no_materia
						else
							@oferta_periodo = OfertaPeriodo.includes(:periodo_academico, :materia, :docente_coordinador, [oferta_academica: :consulta]).find_by(materia: @materia, periodo_academico: @periodo_academico)
							if @oferta_periodo.nil?
								@error = :no_oferta_periodo
								return nil
							else
								@instrumento = @oferta_periodo.oferta_academica.first.consulta.instrumento
								@preguntas = @instrumento.preguntas.where(id: preguntas_ids)
								@resultados = ReportePeriodo.materia_periodo(@oferta_periodo,@preguntas)
							end
						end
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_instrumento
		    ensure
				if @error.nil?
					respond_to do |format|
						format.json { render :reporte_materia_periodo_comparado, status: :ok }
					end
				elsif @error == :no_materia	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
				elsif @error == :no_periodo
					render json: { estatus: "ERROR", mensaje: "El período no existe" }, status: :not_found
				elsif @error == :no_oferta_periodo
					render json: { estatus: "ERROR", mensaje: "El la oferta académica no existe en el período" }, status: :not_found
				end
			end

			# Devuelve la totalización de resultados de cada sección para las preguntas del instrumento aplicado para el período en una materia
			def reporte_periodo_completo_de_materia
				@error = nil
				@periodo_academico = PeriodoAcademico.find_by(periodo: params[:periodo])
				if @periodo_academico.nil?
					@error = :no_periodo
				else
					@materia = Materia.find_by(codigo: params[:codigo_materia])
					if @materia.nil?
						@error = :no_materia
					else
						@oferta_periodo = OfertaPeriodo.includes(:periodo_academico, :materia, :docente_coordinador, [oferta_academica: :consulta]).find_by(materia: @materia, periodo_academico: @periodo_academico)
						if @oferta_periodo.nil?
							@error = :no_oferta_periodo
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
			rescue ActiveRecord::RecordNotFound
				@error = :no_periodo
		    ensure
				if @error.nil?
					respond_to do |format|
						format.json { render :reporte_materia_completo, status: :ok }
						format.pdf do
							pdf = ReporteMateriaCompletoPdf.new(@materia,@instrumento,@resultados,"Reporte Período #{@periodo_academico.periodo}") #Prawn::Document.new
							send_data pdf.render, filename: "reporte-completo-#{@materia.codigo}-periodo-#{@periodo_academico.periodo}.pdf"
						end
					end
				elsif @error == :no_materia	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
				elsif @error == :no_periodo
					render json: { estatus: "ERROR", mensaje: "El período no existe" }, status: :not_found
				end
			end



			######
			# => Reportes Históricos por Docentes
			######

			# Devuelve todos los resultados históricos para una pregunta en una materia
			def reporte_historico_pregunta_de_docente
				@error = nil
				@docente = Docente.find_by(cedula: params[:cedula_docente])
				if @docente.nil?
					@error = :no_docente
				else
					@pregunta = Pregunta.find(params[:pregunta_id])
					if @pregunta.nil?
						@error = :no_pregunta
					else
						@preguntas ||= []
						@preguntas.push(@pregunta)
						@resultados = ReporteHistorico.docente_preguntas(@docente,@preguntas)
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_pregunta
		    ensure
		        if @error.nil?
					respond_to do |format|
						format.json { render :reporte_historico_pregunta_docente, status: :ok }
					end
				elsif @error == :no_docente	
					render json: { estatus: "ERROR", mensaje: "La cédula del docente no está registrada" }, status: :not_found
				elsif @error == :no_pregunta	
					render json: { estatus: "ERROR", mensaje: "La pregunta no está registrada" }, status: :not_found
				end
			end

			# Devuelve todos los resultados de las preguntas especificadas de un instrumento para un docente
			def reporte_historico_completo_de_docente
				@error = nil
				@instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:instrumento_id])
				if @instrumento.nil?
					@error = :no_instrumento
				else
					@docente = Docente.find_by(cedula: params[:cedula_docente])
					if @docente.nil?
						@error = :no_docente
					else
						@preguntas ||= []
						@instrumento.bloques.each do |bloque|
							bloque.preguntas.each do |pregunta|
								@preguntas.push(pregunta)
							end
						end
						if @preguntas.nil? or @preguntas.size == 0
							@error = :no_preguntas
						else
							@resultados = ReporteHistorico.docente_preguntas(@docente,@preguntas)
						end
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_instrumento
		    ensure
				if @error.nil?
					respond_to do |format|
						format.json { render :reporte_docente_completo, status: :ok }
					end
				elsif @error == :no_docente	
					render json: { estatus: "ERROR", mensaje: "La céduña del docente no está registrada" }, status: :not_found
				elsif @error == :no_instrumento	
					render json: { estatus: "ERROR", mensaje: "El instrumento no existe" }, status: :not_found
				elsif @error == :no_preguntas	
					render json: { estatus: "ERROR", mensaje: "Ninguna de las preguntas indicadas fue encontrada en el instrumento." }, status: :not_found
				end
			end
			
			# Devuelve todos los resultados de las preguntas especificadas de un instrumento en una materia
			def reporte_historico_comparado_de_docente
				@error = nil
				if params[:ids].nil? or params[:ids].size == 0
					@error = :no_parameters
				else
					preguntas_ids = params[:ids]
					@docente = Docente.find_by(cedula: params[:cedula_docente])
					if @docente.nil?
						@error = :no_docente
					else
						@instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:instrumento_id])
						@preguntas = @instrumento.preguntas.where(id: preguntas_ids)
						if @preguntas.nil? or @preguntas.size == 0
							@error = :no_preguntas
						else
							@resultados = ReporteHistorico.docente_preguntas(@docente,@preguntas)
						end
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_instrumento
		    ensure
		        if @error.nil?
					respond_to do |format|
						format.json { render :reporte_historico_comparado_docente, status: :ok }
					end
				elsif @error == :no_docente	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada." }, status: :not_found
				elsif @error == :no_instrumento
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada." }, status: :not_found
				elsif @error == :no_preguntas	
					render json: { estatus: "ERROR", mensaje: "Ninguna de las preguntas indicadas fue encontrada en el instrumento." }, status: :not_found
				elsif @error == :no_parameters	
					render json: { estatus: "ERROR", mensaje: "No se detectaron parámetros para la comparación." }.to_json, status: :bad_request
				end
			end

		end
	end
end
