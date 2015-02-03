module Api
  module V1
    class ConsultasController < ApplicationController
      before_action :set_consulta, only: [:show, :edit, :update, :destroy]

      # GET /consultas
      # GET /consultas.json
      def index
        @consultas = Consulta.all
      end

      # GET /consultas/1
      # GET /consultas/1.json
      def show
      end

      # GET /consultas/new
      def new
        @consulta = Consulta.new
      end

      # GET /consultas/1/edit
      def edit
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

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_consulta
          @consulta = Consulta.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def consulta_params
          params.require(:consulta).permit(:oferta_academica_id, :instrumento_id)
        end
    end
  end
end