require 'json'

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
          respuesta_conest = JSON.parse(obtener_de_conest_api('asignaturas', periodo_academico_id))

          if respuesta_conest['estatus'] == 'OK'
            # Datos de la respuesta enviada por Conest
            datos_conest = respuesta_conest['datos']

            @periodo_academico = PeriodoAcademico.find_or_initialize_by(periodo: datos_conest['periodo_academico_id'])

            estatus = @periodo_academico.sincronizar_periodo(respuesta_conest, datos_conest, instrumento_id)
            case estatus
            when :created
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{@periodo_academico.periodo} registrado" }, status: :created
            when :not_modified
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{@periodo_academico.periodo} sin modificaciones" }, status: :not_modified
            when :ok
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{@periodo_academico.periodo} actualizado", sincronizacion: @periodo_academico.sincronizacion }, status: :ok
            else
              nil
            end
          else
            render json: { estatus: respuesta_conest['estatus'], mensaje: respuesta_conest['mensaje'] }, status: :bad_request
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
        @periodo_academico = PeriodoAcademico.find_by(periodo: periodo_academico_id)

        if @periodo_academico
          respuesta_conest = JSON.parse(obtener_de_conest_api('asignaturas', periodo_academico_id))

          if respuesta_conest['estatus'] == 'OK'
            # Datos de la respuesta enviada por Conest
            datos_conest = respuesta_conest['datos']

            instrumento_id = Instrumento.last.id;

            estatus = @periodo_academico.sincronizar_periodo(respuesta_conest, datos_conest, instrumento_id)              
            case estatus
            when :not_modified
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{@periodo_academico.periodo} sin modificaciones" }, status: :not_modified
            when :ok
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Controles de consultas para período #{@periodo_academico.periodo} actualizados", sincronizacion: @periodo_academico.sincronizacion }, status: :ok
            else
              nil
            end
          else
            render json: { estatus: respuesta_conest['estatus'], mensaje: respuesta_conest['mensaje'] }, status: :bad_request
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
          respuesta_conest = JSON.parse(obtener_de_conest_api('estudiantes', periodo_academico_id))

          if respuesta_conest['estatus'] == 'OK'
            estatus = @periodo_academico.sincronizar_estudiantes(respuesta_conest)
            case estatus
            when :not_modified
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Período #{@periodo_academico.periodo} sin modificaciones" }, status: :not_modified
            when :ok
              render json: { estatus: respuesta_conest['estatus'], mensaje: "Controles de consultas para período #{@periodo_academico.periodo} actualizados", sincronizacion: @periodo_academico.sincronizacion }, status: :ok
            else
              nil
            end
          else
            render json: { estatus: respuesta_conest['estatus'], mensaje: respuesta_conest['mensaje'] }, status: :bad_request
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
          if(Token::actual.nil?)
            return { code: 409, estatus: 'ERROR', mensaje: "Debe generar un token para la aplicación. Ejecute una llamada POST hacia la siguiente URL: #{request.base_url}/api/v1/tokens" }.to_json
          end

          if(solicitud == "asignaturas")
            respuesta = RestClient.get "#{CONEST_API[:base_url]}/asignaturas_en_periodo_academico/#{periodo_academico}",
                                    :conest_token  => Token::actual
          elsif(solicitud == "estudiantes")
            respuesta = RestClient.get "#{CONEST_API[:base_url]}/estudiantes_y_asignaturas_en_periodo_academico/#{periodo_academico}",
                                    :conest_token  => Token::actual
          end
          return respuesta
        end
    end
  end
end
