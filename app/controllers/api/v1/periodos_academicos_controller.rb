module Api
  module V1
    class PeriodosAcademicosController < ApplicationController
      before_action :set_periodo_academico, only: [:show, :update, :destroy, :control_consultas]

      # GET /periodos_academicos
      # GET /periodos_academicos.json
      def index
        @periodos_academicos = PeriodoAcademico.all
      end

      # GET /periodos_academicos/1
      # GET /periodos_academicos/1.json
      def show
      end

      # Crea un período académico conectándose a CONEST para obtener toda la información necesaria sobre el período. 
      # De CONEST obtiene las ofertas académicas (asignaturas, secciones y docentes).
      # POST /periodos_academicos
      # POST /periodos_academicos.json
      def create
        periodo_academico_id = periodo_academico_params[:periodo]
        instrumento_id = periodo_academico_params[:instrumento_id]

        if PeriodoAcademico.where(periodo: periodo_academico_params[:periodo]).blank?
          response = obtener_de_conest_api('asignaturas', periodo_academico_id)
          respuesta_conest = JSON.parse(response.body)
  
          if response.code.eql?(200)
            if respuesta_conest['estatus'] == 'OK'
              # Datos de la respuesta enviada por Conest
              datos_conest = respuesta_conest['datos']

              @periodo_academico = PeriodoAcademico.find_or_initialize_by(periodo: datos_conest['periodo_academico_id'])

              sincronizar_periodo(@periodo_academico, respuesta_conest, datos_conest, instrumento_id)
            else
              render json: { estatus: respuesta_conest['estatus'], mensaje: respuesta_conest['mensaje'] }, status: :bad_request
            end
          else
            render nothing: true, status: response.code
          end
        else
          render json: { estatus: 'ERROR', mensaje: 'El período ya fue registrado anteriormente' }, status: :not_modified
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

      # Crea un período académico conectándose a CONEST para obtener toda la información necesaria sobre el período. 
      # De CONEST obtiene las ofertas académicas (asignaturas, secciones y docentes).
      # POST /periodos_academicos
      # POST /periodos_academicos.json
      def sincronizar_asignaturas
        periodo_academico_id = params[:periodo]

        @periodo_academico = PeriodoAcademico.find_or_initialize_by(periodo: periodo_academico_id)

        if @periodo_academico
          response = obtener_de_conest_api('asignaturas', periodo_academico_id)
          respuesta_conest = JSON.parse(response.body)
          if response.code.eql?(200)
            if respuesta_conest['estatus'] == 'OK'
              # Datos de la respuesta enviada por Conest
              datos_conest = respuesta_conest['datos']

              instrumento_id = Instrumento.last;

              sincronizar_periodo(@periodo_academico, respuesta_conest, datos_conest, instrumento_id)              
            else
              render json: { estatus: respuesta_conest['estatus'], mensaje: respuesta_conest['mensaje'] }, status: :bad_request
            end
          else
            render nothing: true, status: response.code
          end
        else
          render json: { estatus: 'ERROR', mensaje: "El período #{periodo_academico_id} no está registrado" }, status: :not_found
        end
      end

      # Sincroniza los estudiantes de las distintas ofertas académicas registradas en CONEST para el período indicado
      # GET /periodos_academicos/01-2014/sincronizar_estudiantes
      # GET /periodos_academicos/01-2014/sincronizar_estudiantes.json
      def sincronizar_estudiantes
        periodo_academico_id = params[:periodo]

        @periodo_academico = PeriodoAcademico.find_by(periodo: periodo_academico_id)

        if @periodo_academico
          response = obtener_de_conest_api('estudiantes', periodo_academico_id)
          respuesta_conest = JSON.parse(response.body)

          if response.code.eql?(200)
            if respuesta_conest['estatus'] == 'OK'
              # Datos de la respuesta enviada por Conest
              datos_conest = respuesta_conest['datos']

              # Si el hash es el mismo no hay cambios en el listado
              if @periodo_academico.estudiantes_hash_sum.eql?(respuesta_conest['sha1_sum'])
                render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{@periodo_academico.periodo} sin modificaciones" }, status: :not_modified
              else
                @periodo_academico.update(estudiantes_hash_sum: respuesta_conest['sha1_sum'], sincronizacion: respuesta_conest['fecha_hora'])
                datos_conest['carreras'].each do |c|
                  @carrera = Carrera.find_by(codigo: c['id'])
                  c['estudiantes'].each do |e|
                    # Obtengo el Estudiante
                    @estudiante = Estudiante.find_or_initialize_by(cedula: e['cedula'])
                    @estudiante.update(cedula: e['cedula'], primer_nombre: e['primer_nombre'], segundo_nombre: e['segundo_nombre'], primer_apellido: e['primer_apellido'], segundo_apellido: e['segundo_apellido'])

                    # Creación de usuarios de Estudiante
                    unless Usuario.exists?(cedula: @estudiante.cedula)
                      rol = Rol.find_by(nombre: 'Estudiante')
                      usuario = Usuario.create(cedula: @estudiante.cedula, clave: @estudiante.cedula, rol: rol)
                    end
                    
                    e['materias'].each do |m|
                      @materia = Materia.find_by(codigo: m['codigo'], carrera: @carrera)
                      @oferta_periodo = @materia.ofertas_periodo.find_by(periodo_academico: @periodo_academico)
                      @oferta_academica = @oferta_periodo.oferta_academica.find_by(oferta_periodo: @oferta_periodo, nombre_seccion: m['nombre_seccion'])

                      @control_consulta = ControlConsulta.find_or_create_by(oferta_academica: @oferta_academica, estudiante: @estudiante)
                    end
                  end
                end
                render json: { estatus: respuesta_conest['estatus'], mensaje: "Controles de consultas para período #{@periodo_academico.periodo} actualizados", sincronizacion: @periodo_academico.sincronizacion }, status: :ok
              end
            else
              render json: { estatus: respuesta_conest['estatus'], mensaje: respuesta_conest['mensaje'] }, status: :bad_request
            end
          else
            render nothing: true, status: response.code
          end
        else
          render json: { estatus: 'ERROR', mensaje: "El período #{periodo_academico_id} no está registrado" }, status: :not_found
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_periodo_academico
          @periodo_academico = PeriodoAcademico.find_by(periodo: params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def periodo_academico_params
          params.require(:periodo_academico).permit(:periodo, :instrumento_id)
        end

        def obtener_de_conest_api(solicitud, periodo_academico)
          respuesta = nil
          if(solicitud == "asignaturas")
            respuesta = RestClient.get "#{CONEST_API[:base_url]}/asignaturas_en_periodo_academico/#{periodo_academico}",
                                    :conest_token  => Token::actual
          elsif(solicitud == "estudiantes")
            respuesta = RestClient.get "#{CONEST_API[:base_url]}/estudiantes_y_asignaturas_en_periodo_academico/#{periodo_academico}",
                                    :conest_token  => Token::actual
          end
          return respuesta
        end

        def sincronizar_periodo(periodo_academico, respuesta_conest, datos_conest, instrumento_id)
          if periodo_academico.id.nil?
            # Crear el nuevo periodo academico
            periodo_academico.update(asignaturas_hash_sum: respuesta_conest['sha1_sum'], sincronizacion: respuesta_conest['fecha_hora'])
            procesar_periodo(periodo_academico, datos_conest, instrumento_id)
            render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{periodo_academico.periodo} registrado" }, status: :created
          else
            # Si el hash es el mismo no hay cambios en el listado
            if periodo_academico.asignaturas_hash_sum.eql?(respuesta_conest['sha1_sum'])
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{periodo_academico.periodo} sin modificaciones" }, status: :not_modified
            else
              # Si no es el mismo, actualizo y continuo
              periodo_academico.update(asignaturas_hash_sum: respuesta_conest['sha1_sum'], sincronizacion: respuesta_conest['fecha_hora'])
              procesar_periodo(periodo_academico, datos_conest, instrumento_id)
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{periodo_academico.periodo} actualizado", sincronizacion: @periodo_academico.sincronizacion }, status: :ok
            end
          end
        end

        # Método que procesa la información recibida desde CONEST sobre el período académico registrado
        # En 'd' se contienen los datos de la respuesta enviada por CONEST
        def procesar_periodo(periodo_academico, datos_conest, instrumento_id = nil)
          # Iterar sobre las organizaciones (Escuelas)
          datos_conest['organizaciones'].each do |o|
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
                
                # Creación de usuario de Coordinador
                unless Usuario.exists?(cedula: @coordinador.cedula)
                  rol = Rol.find_by(nombre: 'Docente')
                  usuario = Usuario.create(cedula: @coordinador.cedula, clave: @coordinador.cedula, rol: rol)
                end


                # Obtengo la oferta en el periodo
                @oferta_periodo = OfertaPeriodo.find_or_initialize_by(periodo_academico: periodo_academico, materia: @materia)
                @oferta_periodo.update(docente_coordinador: @coordinador)
                
                # Para cada Seccion de cada Materia
                m['secciones'].each do |s|

                  # Obtengo el docente
                  @docente = Docente.find_or_initialize_by(cedula: s['docente']['cedula'])
                  @docente.update(s['docente'])

                  # Creación de usuarios de Docente
                  unless Usuario.exists?(cedula: @docente.cedula)
                    rol = Rol.find_by(nombre: 'Docente')
                    usuario = Usuario.create(cedula: @docente.cedula, clave: @docente.cedula, rol: rol)
                  end
                  
                  # Registro la oferta academica para ese periodo
                  @oferta_academica = OfertaAcademica.find_or_initialize_by(nombre_seccion: s['nombre'], oferta_periodo: @oferta_periodo)
                  @oferta_academica.update(docente: @docente, promedio_general: s['promedio_general'], nro_estudiantes: s['nro_estudiantes'], nro_estudiantes_retirados: s['nro_estudiantes_retirados'], nro_estudiantes_aprobados: s['nro_estudiantes_aprobados'], nro_estudiantes_equivalencia: s['nro_estudiantes_equivalencia'], nro_estudiantes_suficiencia: s['nro_estudiantes_suficiencia'], nro_estudiantes_reparacion: s['nro_estudiantes_repararon'], nro_estudiantes_aplazados: s['nro_estudiantes_aplazados'], tipo_estatus_calificacion_id: s['tipo_status_calificacion_id'])

                  @consulta = Consulta.find_or_initialize_by(oferta_academica: @oferta_academica)
                  

                  instrumento = instrumento_id.nil? ? Instrumento.all.last : Instrumento.find(instrumento_id)

                  @consulta.update(instrumento: instrumento)
                end
              end
            end
          end
        end
    end
  end
end
