module Api
  module V1
    class PeriodosAcademicosController < ApplicationController
      before_action :set_periodo_academico, only: [:show, :edit, :update, :destroy, :control_consultas]

      # GET /periodos_academicos
      # GET /periodos_academicos.json
      def index
        @periodos_academicos = PeriodoAcademico.all
      end

      # GET /periodos_academicos/1
      # GET /periodos_academicos/1.json
      def show
      end

      # GET /periodos_academicos/new
      def new
        @periodo_academico = PeriodoAcademico.new
      end

      # GET /periodos_academicos/1/edit
      def edit
      end

      # POST /periodos_academicos
      # POST /periodos_academicos.json
      def create
        periodo_academico_id = periodo_academico_params[:periodo]

        response = RestClient.get "#{CONEST_API[:base_url]}/asignaturas_en_periodo_academico/#{periodo_academico_id}",
                                  :conest_token  => Token::actual
        r = JSON.parse(response.body)

        if response.code.eql?(200)
          if r['estatus'] == 'OK'
            # Datos de la respuesta enviada por Conest
            d = r['datos']

            @periodo_academico = PeriodoAcademico.find_or_initialize_by(periodo: d['periodo_academico_id'])

            if @periodo_academico.id.nil?
              # Crear el nuevo periodo academico
              @periodo_academico.update(asignaturas_hash_sum: r['sha1_sum'], sincronizacion: r['fecha_hora'])
              procesar_periodo(@periodo_academico, d)
              render json: { estatus: r['estatus'], mensaje: "Período #{@periodo_academico.periodo} registrado" }, status: :created
            else
              # Si el hash es el mismo no hay cambios en el listado
              if @periodo_academico.asignaturas_hash_sum.eql?(r['sha1_sum'])
                render json: { estatus: r['estatus'], mensaje: "Período #{@periodo_academico.periodo} sin modificaciones" }, status: :not_modified
              else
                # Si no es el mismo, actualizo y continuo
                @periodo_academico.update(asignaturas_hash_sum: r['sha1_sum'], sincronizacion: r['fecha_hora'])
                procesar_periodo(@periodo_academico, d)
                render json: { estatus: r['estatus'], mensaje: "Período #{@periodo_academico.periodo} actualizado" }, status: :ok
              end
            end
          else
            render json: { estatus: r['estatus'], mensaje: r['mensaje'] }, status: :bad_request
          end
        else
          render nothing: true, status: response.code
        end
      end

      # PATCH/PUT /periodos_academicos/1
      # PATCH/PUT /periodos_academicos/1.json
      def update
        respond_to do |format|
          if @periodo_academico.update(periodo_academico_params)
            format.html { redirect_to @periodo_academico, notice: 'Periodo academico was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_periodo_academico_url(@periodo_academico) }
          else
            format.html { render :edit }
            format.json { render json: @periodo_academico.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /periodos_academicos/1
      # DELETE /periodos_academicos/1.json
      def destroy
        @periodo_academico.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_periodos_academicos_url, notice: 'Periodo academico was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      # POST /periodos_academicos/1/control_consultas
      # POST /periodos_academicos/1/control_consultas.json
      def generar_control
        periodo_academico_id = params[:periodo]

        response = RestClient.get "#{CONEST_API[:base_url]}/estudiantes_y_asignaturas_en_periodo_academico/#{periodo_academico_id}",
                                  :conest_token  => Token::actual
        r = JSON.parse(response.body)

        if response.code.eql?(200)
          if r['estatus'] == 'OK'
            # Datos de la respuesta enviada por Conest
            d = r['datos']

            @periodo_academico = PeriodoAcademico.find_by(periodo: d['periodo_academico_id'])

            if @periodo_academico.nil?
              render json: { estatus: r['estatus'], mensaje: "Período #{d['periodo_academico_id']} no está registrado" }, status: :not_found
            else
              # Si el hash es el mismo no hay cambios en el listado
              if @periodo_academico.estudiantes_hash_sum.eql?(r['sha1_sum'])
                render json: { estatus: r['estatus'], mensaje: "Período #{@periodo_academico.periodo} sin modificaciones" }, status: :not_modified
              else
                @periodo_academico.update(estudiantes_hash_sum: r['sha1_sum'])
                d['carreras'].each do |c|
                  @carrera = Carrera.find_by(codigo: c['id'])
                  c['estudiantes'].each do |e|
                    # Obtengo el Estudiante
                    @estudiante = Estudiante.find_or_initialize_by(cedula: e['cedula'])
                    @estudiante.update(cedula: e['cedula'], primer_nombre: e['primer_nombre'], segundo_nombre: e['segundo_nombre'], primer_apellido: e['primer_apellido'], segundo_apellido: e['segundo_apellido'])
                    
                    e['materias'].each do |m|
                      @materia = Materia.find_by(codigo: m['codigo'], carrera: @carrera)
                      @oferta_periodo = @materia.ofertas_periodo.find_by(periodo_academico: @periodo_academico)
                      @oferta_academica = @oferta_periodo.oferta_academica.find_by(oferta_periodo: @oferta_periodo, nombre_seccion: m['nombre_seccion'])

                      @control_consulta = ControlConsulta.find_or_create_by(oferta_academica: @oferta_academica, estudiante: @estudiante)
                    end
                  end
                end
                render json: { estatus: r['estatus'], mensaje: "Controles para período #{@periodo_academico.periodo} actualizados" }, status: :ok
              end
            end
          else
            render json: { estatus: r['estatus'], mensaje: r['mensaje'] }, status: :bad_request
          end
        else
          render nothing: true, status: response.code
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_periodo_academico
          @periodo_academico = PeriodoAcademico.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def periodo_academico_params
          params.require(:periodo_academico).permit(:periodo)
        end

        def procesar_periodo(periodo_academico, d)
          # Iterar sobre las organizaciones (Escuelas)
          d['organizaciones'].each do |o|
            # Para cada Carrera de cada Organizacion
            o['carreras'].each do |c|
              @carrera = Carrera.find_or_initialize_by(codigo: c['id'], organizacion_id: o['id'])
              if @carrera.id.nil?
                @carrera.update(nombre: c['nombre'])
              end

              # Para cada Materia de cada Carrera
              c['materias'].each do |m|
                @materia = Materia.find_or_initialize_by(carrera: @carrera, plan_nombre: c['plan_nombre'], codigo: m['codigo'])
                if @materia.id.nil?
                  @materia.update(nombre: m['nombre'], tipo_materia_id: m['tipo_materia_id'], grupo_nota_id: m['grupo_nota_id'])
                end
                
                # Obtengo el Coordinador
                @coordinador = Docente.find_or_initialize_by(cedula: m['coordinador']['cedula'])
                @coordinador.update(m['coordinador'])
                
                # Obtengo la oferta en el periodo
                @oferta_periodo = OfertaPeriodo.find_or_initialize_by(periodo_academico: periodo_academico, materia: @materia)
                @oferta_periodo.update(docente_coordinador: @coordinador)
                
                # Para cada Seccion de cada Materia
                m['secciones'].each do |s|

                  # Obtengo el docente
                  @docente = Docente.find_or_initialize_by(cedula: s['docente']['cedula'])
                  @docente.update(s['docente'])
                  
                  # Registro la oferta academica para ese periodo
                  @oferta_academica = OfertaAcademica.find_or_initialize_by(nombre_seccion: s['nombre'], oferta_periodo: @oferta_periodo)
                  @oferta_academica.update(docente: @docente, promedio_general: s['promedio_general'], nro_estudiantes: s['nro_estudiantes'], nro_estudiantes_retirados: s['nro_estudiantes_retirados'], nro_estudiantes_aprobados: s['nro_estudiantes_aprobados'], nro_estudiantes_equivalencia: s['nro_estudiantes_equivalencia'], nro_estudiantes_suficiencia: s['nro_estudiantes_suficiencia'], nro_estudiantes_reparacion: s['nro_estudiantes_repararon'], nro_estudiantes_aplazados: s['nro_estudiantes_aplazados'], tipo_estatus_calificacion_id: s['tipo_status_calificacion_id'])
                end
              end
            end
          end
        end
    end
  end
end
