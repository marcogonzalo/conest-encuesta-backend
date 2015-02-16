module Api
  module V1
    class PreguntasController < ApplicationController
      before_action :set_pregunta, only: [:show, :update, :destroy]

      # GET /preguntas
      # GET /preguntas.json
      def index
        @preguntas = Pregunta.all
      end

      # GET /preguntas/1
      # GET /preguntas/1.json
      def show
      end

      # POST /preguntas
      # POST /preguntas.json
      def create
        @pregunta = Pregunta.new(pregunta_params)

        respond_to do |format|
          if @pregunta.save
            format.html { redirect_to @pregunta, notice: 'Pregunta was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_pregunta_url(@pregunta) }
          else
            format.html { render :new }
            format.json { render json: @pregunta.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /preguntas/1
      # PATCH/PUT /preguntas/1.json
      def update
        respond_to do |format|
          if @pregunta.update(pregunta_params)
            format.html { redirect_to @pregunta, notice: 'Pregunta was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_pregunta_url(@pregunta) }
          else
            format.html { render :edit }
            format.json { render json: @pregunta.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /preguntas/1
      # DELETE /preguntas/1.json
      def destroy
        @pregunta.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_preguntas_url, notice: 'Pregunta was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_pregunta
          @pregunta = Pregunta.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def pregunta_params
          params.require(:pregunta).permit(:interrogante, :descripcion, :tipo_pregunta_id)
        end
    end
  end
end
