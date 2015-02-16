module Api
  module V1
    class TiposPreguntaController < ApplicationController
      before_action :set_tipo_pregunta, only: [:show, :update, :destroy]

      # GET /tipos_pregunta
      # GET /tipos_pregunta.json
      def index
        @tipos_pregunta = TipoPregunta.all
      end

      # GET /tipos_pregunta/1
      # GET /tipos_pregunta/1.json
      def show
      end

      # POST /tipos_pregunta
      # POST /tipos_pregunta.json
      def create
        @tipo_pregunta = TipoPregunta.new(tipo_pregunta_params)

        respond_to do |format|
          if @tipo_pregunta.save
            format.html { redirect_to @tipo_pregunta, notice: 'Tipo pregunta was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_tipo_pregunta_url(@tipo_pregunta) }
          else
            format.html { render :new }
            format.json { render json: @tipo_pregunta.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /tipos_pregunta/1
      # PATCH/PUT /tipos_pregunta/1.json
      def update
        respond_to do |format|
          if @tipo_pregunta.update(tipo_pregunta_params)
            format.html { redirect_to @tipo_pregunta, notice: 'Tipo pregunta was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_tipo_pregunta_url(@tipo_pregunta) }
          else
            format.html { render :edit }
            format.json { render json: @tipo_pregunta.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /tipos_pregunta/1
      # DELETE /tipos_pregunta/1.json
      def destroy
        @tipo_pregunta.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_tipos_pregunta_url, notice: 'Tipo pregunta was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_tipo_pregunta
          @tipo_pregunta = TipoPregunta.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def tipo_pregunta_params
          params.require(:tipo_pregunta).permit(:nombre, :valor, :valor_html)
        end
    end
  end
end
