module Api
  module V1
    class InstrumentosController < ApplicationController
      before_action :set_instrumento, only: [:show, :update, :destroy]

      # GET /instrumentos
      # GET /instrumentos.json
      def index
        @instrumentos = Instrumento.all
      end

      # GET /instrumentos/1
      # GET /instrumentos/1.json
      def show
        @instrumento = Instrumento.includes(bloques:{preguntas:[:tipo_pregunta, :opciones]}).find(params[:id])
      end

      # POST /instrumentos
      # POST /instrumentos.json
      def create
        @instrumento = Instrumento.new(instrumento_params)

        respond_to do |format|
          if @instrumento.save
            format.html { redirect_to @instrumento, notice: 'Instrumento was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_instrumento_url(@instrumento) }
          else
            format.html { render :new }
            format.json { render json: @instrumento.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /instrumentos/1
      # PATCH/PUT /instrumentos/1.json
      def update
        respond_to do |format|
          if @instrumento.update(instrumento_params)
            format.html { redirect_to @instrumento, notice: 'Instrumento was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_instrumento_url(@instrumento) }
          else
            format.html { render :edit }
            format.json { render json: @instrumento.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /instrumentos/1
      # DELETE /instrumentos/1.json
      def destroy
        @instrumento.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_instrumentos_url, notice: 'Instrumento was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_instrumento
          @instrumento = Instrumento.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def instrumento_params
          params.require(:instrumento).permit(:nombre, :descripcion, bloques_attributes: [
                                                :nombre, :descripcion, :tipo, 
                                                preguntas_attributes: [
                                                  :id, :interrogante, :descripcion, :tipo_pregunta_id, 
                                                  opciones_attributes: [
                                                    :id, :etiqueta, :valor 
                                                  ]
                                                ]
                                              ], bloque_ids: [])
        end
    end
  end
end
