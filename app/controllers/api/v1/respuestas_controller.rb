module Api
  module V1
    class RespuestasController < ApplicationController
      before_action :set_respuesta, only: [:show]

      # GET /respuestas
      # GET /respuestas.json
      def index
        @respuestas = Respuesta.all
      end

      # GET /respuestas/1
      # GET /respuestas/1.json
      def show
      end

      # POST /respuestas
      # POST /respuestas.json
      def create
        @respuesta = Respuesta.new(respuesta_params)

        respond_to do |format|
          if @respuesta.save
            format.html { redirect_to @respuesta, notice: 'Respuesta was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_respuesta_url(@respuesta) }
          else
            format.html { render :new }
            format.json { render json: @respuesta.errors, status: :unprocessable_entity }
          end
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_respuesta
          @respuesta = Respuesta.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def respuesta_params
          params.require(:respuesta).permit(:consulta_id, :pregunta_id, :valor)
        end
    end
  end
end
