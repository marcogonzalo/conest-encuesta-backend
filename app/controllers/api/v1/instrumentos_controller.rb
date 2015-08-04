module Api
  module V1
    class InstrumentosController < ApplicationController
      
      before_action :set_instrumento, only: [:show, :update, :destroy]

      load_and_authorize_resource
      before_action :cargar_permisos # call this after load_and_authorize else it gives a cancan error

      # GET /instrumentos
      # GET /instrumentos.json
      def index
        @instrumentos = Instrumento.all
      end

      # Retorna un instrumento con sus bloques, preguntas y opciones
      # GET /instrumentos/1
      # GET /instrumentos/1.json
      def show
        @instrumento = Instrumento.includes(bloques:{preguntas:[:opciones]}).find(params[:id])
      end

      # Crea un instrumento según los parámetros recibidos. 
      # Podría crear un instrumento completo si se cumple con todos los parámetros
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

      # Actualiza un instrumento según los parámetros recibidos. 
      # Podría actualizar un instrumento completo si se cumple con todos los parámetros
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
          json_instrumento_params = params.require(:instrumento).permit(:nombre, :descripcion, 
                                              bloques: [
                                                :id, :nombre, :descripcion, :tipo, 
                                                preguntas: [
                                                  :id, :interrogante, :descripcion, :tipo_pregunta, 
                                                  opciones: [
                                                    :id, :etiqueta, :valor 
                                                  ]
                                                ]
                                              ], bloque_ids: [])
          PrettyApi.with_nested_attributes(json_instrumento_params,bloques: [preguntas: [:opciones]])
        end
    end
  end
end
