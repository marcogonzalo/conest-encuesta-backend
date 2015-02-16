module Api
  module V1
    class ConsultasController < ApplicationController
      before_action :set_consulta, only: [:show, :update, :destroy, :responder]

      # GET /consultas
      # GET /consultas.json
      def index
        @consultas = Consulta.all
      end

      # GET /consultas/1
      # GET /consultas/1.json
      def show
      end

      # POST /consultas
      # POST /consultas.json
      def create
        @consulta = Consulta.new(consulta_params)

        respond_to do |format|
          if @consulta.save
            format.html { redirect_to @consulta, notice: 'Consulta was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_consulta_url(@consulta) }
          else
            format.html { render :new }
            format.json { render json: @consulta.errors, status: :unprocessable_entity }
          end
        end
      end

      # POST /consultas
      # POST /consultas.json
      def create
        @consulta = Consulta.new(consulta_params)

        respond_to do |format|
          if @consulta.save
            format.html { redirect_to @consulta, notice: 'Consulta was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_consulta_url(@consulta) }
          else
            format.html { render :new }
            format.json { render json: @consulta.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /consultas/1
      # PATCH/PUT /consultas/1.json
      def update
        respond_to do |format|
          if @consulta.update(consulta_params)
            format.html { redirect_to @consulta, notice: 'Consulta was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_consulta_url(@consulta) }
          else
            format.html { render :edit }
            format.json { render json: @consulta.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /consultas/1
      # DELETE /consultas/1.json
      def destroy
        @consulta.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_consultas_url, notice: 'Consulta was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      # POST /consultas/1/responder
      # POST /consultas/1/responder.json
      def responder
        cedula_estudiante = responder_consulta_params[:cedula_estudiante]
        respuestas = responder_consulta_params[:respuestas]

        # Se verifica si el estudiante es valido
        @estudiante = Estudiante.find_by(cedula: cedula_estudiante)
        if @estudiante
          # Se verifica la asociacion entre el estudiante y la oferta academica
          @control = ControlConsulta.find_by(oferta_academica_id: @consulta.oferta_academica_id, estudiante_id: @estudiante.id)
          if not @control.nil?
            # Si la persona no ha respondido la consulta
            if not @control.respondida
              # Se almacenan las respuestas
              respuestas.each do |r|
                @respuesta = Respuesta.new(consulta: @consulta, pregunta_id: r['pregunta_id'], valor: r['valor'])
                @respuesta.save
              end
              # Se marca la consulta como respondida
              ControlConsulta.where(oferta_academica_id: @consulta.oferta_academica_id, estudiante_id: @estudiante.id).update_all(respondida: true)
              render json: { estatus: "OK", mensaje: "Registrada respuesta a la consulta" }, status: :created
            else
              puts "Dsfsdf"
              render json: { estatus: "OK", mensaje: "Estudiante ya respodió la consulta" }, status: :not_modified
            end
          else
            render json: { estatus: "ERROR", mensaje: "Consulta/Oferta no asociada a estudiante" }, status: :forbidden
          end
        else
          render json: { estatus: "ERROR", mensaje: "Cédula #{cedula_estudiante} no se encuentra registrada" }, status: :forbidden
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_consulta
          @consulta = Consulta.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def consulta_params
          params.require(:consulta).permit(:oferta_academica_id, :instrumento_id)
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def responder_consulta_params
          params.require(:consulta).permit(:cedula_estudiante, respuestas: [:pregunta_id, :valor])
        end
    end
  end
end