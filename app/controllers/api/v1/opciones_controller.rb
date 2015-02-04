module Api
  module V1
    class OpcionesController < ApplicationController
      before_action :set_opcion, only: [:show, :edit, :update, :destroy]

      # GET /opciones
      # GET /opciones.json
      def index
        @opciones = Opcion.all
      end

      # GET /opciones/1
      # GET /opciones/1.json
      def show
      end

      # GET /opciones/new
      def new
        @opcion = Opcion.new
      end

      # GET /opciones/1/edit
      def edit
      end

      # POST /opciones
      # POST /opciones.json
      def create
        @opcion = Opcion.new(opcion_params)

        respond_to do |format|
          if @opcion.save
            format.html { redirect_to @opcion, notice: 'Opcion was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_pregunta_opcion_url(@opcion.pregunta_id,@opcion) }
          else
            format.html { render :new }
            format.json { render json: @opcion.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /opciones/1
      # PATCH/PUT /opciones/1.json
      def update
        respond_to do |format|
          if @opcion.update(opcion_params)
            format.html { redirect_to @opcion, notice: 'Opcion was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_pregunta_opcion_url(@opcion.pregunta_id,@opcion) }
          else
            format.html { render :edit }
            format.json { render json: @opcion.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /opciones/1
      # DELETE /opciones/1.json
      def destroy
        @opcion.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_opciones_url, notice: 'Opcion was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_opcion
          @opcion = Opcion.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def opcion_params
          params.require(:opcion).permit(:etiqueta, :valor, :pregunta_id)
        end
    end
  end
end
