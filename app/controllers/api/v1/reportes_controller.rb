require 'csv'
module Api
	module V1
		class ReportesController < ApplicationController
			######
			# => Reportes Históricos de Materias
			######

			# Devuelve todos los resultados históricos para una pregunta en una materia
			# GET /api/v1/reportes/historico_pregunta/materias/6014/preguntas/1.json
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
							pdf = ReporteMateriaHistoricoPreguntaPdf.new(@materia,@pregunta,@resultados) #Prawn::Document.new
							send_data pdf.render, filename: "reporte-materia-#{@materia.codigo}-historico-pregunta.pdf"
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
			# GET /api/v1/reportes/historico_comparado/materias/6014/instrumentos/1.json?ids[]=1
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
						@preguntas = @instrumento.preguntas.includes(:opciones).where(id: preguntas_ids)
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
			# GET /api/v1/reportes/historico_completo/materias/6014/instrumentos/1.json
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
						@instrumento.bloques.includes(:preguntas).each do |bloque|
							bloque.preguntas.includes(:opciones).each do |pregunta|
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
							pdf = ReporteMateriaHistoricoCompletoPdf.new(@materia,@instrumento,@resultados,"Reporte histórico") #Prawn::Document.new
							send_data pdf.render, filename: "reporte-materia-#{@materia.codigo}-historico-completo.pdf"
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
								@preguntas = @instrumento.preguntas.includes(:opciones).where(id: preguntas_ids)
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
							@instrumento.bloques.includes(:preguntas).each do |bloque|
								bloque.preguntas.includes(:opciones).each do |pregunta|
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
							pdf = ReporteMateriaPeriodoCompletoPdf.new(@materia,@instrumento,@resultados,"Reporte Período #{@periodo_academico.periodo}") #Prawn::Document.new
							send_data pdf.render, filename: "reporte-materia-#{@materia.codigo}-periodo-#{@periodo_academico.periodo}-completo.pdf"
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
			# GET /api/v1/reportes/historico_comparado/docentes/12243532/preguntas/1.json
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
						format.pdf do
							pdf = ReporteDocenteHistoricoPreguntaPdf.new(@docente,@pregunta,@resultados) #Prawn::Document.new
							send_data pdf.render, filename: "reporte-docente-#{@docente.cedula}-historico-pregunta.pdf"
						end
					end
				elsif @error == :no_docente	
					render json: { estatus: "ERROR", mensaje: "La cédula del docente no está registrada" }, status: :not_found
				elsif @error == :no_pregunta	
					render json: { estatus: "ERROR", mensaje: "La pregunta no está registrada" }, status: :not_found
				end
			end

			# Devuelve todos los resultados de las preguntas especificadas de un instrumento para un docente
			# GET /api/v1/reportes/historico_comparado/docentes/12243532/instrumentos/1.json
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
						@instrumento.bloques.includes(:preguntas).each do |bloque|
							bloque.preguntas.includes(:opciones).each do |pregunta|
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
						format.pdf do
							pdf = ReporteDocenteHistoricoCompletoPdf.new(@docente,@instrumento,@resultados,"Reporte histórico") #Prawn::Document.new
							send_data pdf.render, filename: "reporte-docente-#{@docente.cedula}-historico-completo.pdf"
						end
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
			# GET /api/v1/reportes/historico_comparado/docentes/12243532/instrumentos/1.json?ids[]=1
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



			######
			# => Reportes de Período por Docente
			######

			# Devuelve los resultados de las preguntas especificadas de instrumento aplicado para el período en un docente
			# GET /api/v1/reportes/historico_comparado/docentes/12243532/periodo/01-2014.json?ids[]=1
			def reporte_periodo_comparado_de_docente
				@error = nil

				if params[:ids].nil?
					@error = :no_parameters
				else
					preguntas_ids = params[:ids]
					@periodo_academico = PeriodoAcademico.find_by(periodo: params[:periodo])
					if @periodo_academico.nil?
						@error = :no_periodo
					else
						@docente = Docente.find_by(cedula: params[:cedula_docente])
						if @docente.nil?
							@error = :no_docente
						else
							@ofertas_academicas = OfertaAcademica.includes(:consulta, :docente, {oferta_periodo: :periodo_academico}).where(docente: @docente, ofertas_periodo: { periodo_academico_id: @periodo_academico.id })
							if @ofertas_academicas.nil?
								@error = :no_oferta_academica
								return nil
							else
								@consultas = Consulta.where(oferta_academica: @ofertas_academicas.ids)
								@preguntas = Pregunta.includes(:opciones).where(id: preguntas_ids)
								@instrumento = Instrumento.includes(:preguntas).where(preguntas: { id: @preguntas.first.id }).first

								if @preguntas.nil? or @preguntas.size == 0
									@error = :no_preguntas
								else
									@resultados = ReportePeriodo.docente_periodo(@ofertas_academicas,@preguntas)
								end
							end
						end
					end
				end
		    ensure
				if @error.nil?
					respond_to do |format|
						format.json { render :reporte_docente_periodo_comparado, status: :ok }
					end
				elsif @error == :no_docente	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
				elsif @error == :no_periodo
					render json: { estatus: "ERROR", mensaje: "El período no existe" }, status: :not_found
				elsif @error == :no_oferta_academica
					render json: { estatus: "ERROR", mensaje: "El la oferta académica no existe en el período" }, status: :not_found
				elsif @error == :no_preguntas	
					render json: { estatus: "ERROR", mensaje: "Ninguna de las preguntas indicadas fue encontrada en el instrumento." }, status: :not_found
				elsif @error == :no_parameters	
					render json: { estatus: "ERROR", mensaje: "No se detectaron parámetros para la comparación." }.to_json, status: :bad_request
				end
			end

			# Devuelve los resultados de las preguntas de instrumento aplicado para el período en un docente
			# GET /api/v1/reportes/historico_comparado/docentes/12243532/periodo/01-2014.json
			def reporte_periodo_completo_de_docente
				@error = nil

				preguntas_ids = params[:ids]
				@periodo_academico = PeriodoAcademico.find_by(periodo: params[:periodo])
				if @periodo_academico.nil?
					@error = :no_periodo
				else
					@docente = Docente.find_by(cedula: params[:cedula_docente])
					if @docente.nil?
						@error = :no_docente
					else
						@ofertas_academicas = OfertaAcademica.includes(:consulta, :docente, {oferta_periodo: :periodo_academico}).where(docente: @docente, ofertas_periodo: { periodo_academico_id: @periodo_academico.id })
						if @ofertas_academicas.nil?
							@error = :no_oferta_academica
							return nil
						else
							@preguntas ||= []
							@instrumento = @ofertas_academicas.first.consulta.instrumento
							@instrumento.bloques.includes(:preguntas).each do |bloque|
								bloque.preguntas.includes(:opciones).each do |pregunta|
									@preguntas.push(pregunta)
								end
							end
							@resultados = ReportePeriodo.docente_periodo(@ofertas_academicas,@preguntas)
						end
					end
				end
			rescue ActiveRecord::RecordNotFound
				@error = :no_instrumento
		    ensure
				if @error.nil?
					respond_to do |format|
						format.json { render :reporte_docente_completo, status: :ok }
						format.pdf do
							pdf = ReporteDocentePeriodoCompletoPdf.new(@docente,@instrumento,@resultados,"Reporte Docente #{@periodo_academico.periodo}") #Prawn::Document.new
							send_data pdf.render, filename: "reporte-docente-#{@docente.cedula}-periodo-#{@periodo_academico.periodo}-completo.pdf"
						end
					end
				elsif @error == :no_docente	
					render json: { estatus: "ERROR", mensaje: "La asignatura no está registrada" }, status: :not_found
				elsif @error == :no_periodo
					render json: { estatus: "ERROR", mensaje: "El período no existe" }, status: :not_found
				elsif @error == :no_oferta_academica
					render json: { estatus: "ERROR", mensaje: "El la oferta académica no existe en el período" }, status: :not_found
				end
			end

		end
	end
end
