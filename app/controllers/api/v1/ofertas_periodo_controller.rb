module Api
  module V1
    class OfertasPeriodoController < ApplicationController
      before_action :set_oferta_periodo, only: [:show, :update, :destroy]
      before_action :set_periodo_academico, only: [:index, :create]

      # GET /ofertas_periodo
      # GET /ofertas_periodo.json
      def index
        @ofertas_periodo = @periodo_academico.ofertas_periodo
      end

      # GET /ofertas_periodo/1
      # GET /ofertas_periodo/1.json
      def show
      end

      # POST /ofertas_periodo
      # POST /ofertas_periodo.json
      def create
        @oferta_periodo = OfertaPeriodo.new(materia_id: oferta_periodo_params[:materia_id], periodo_academico_id: oferta_periodo_params[:periodo_academico_id], docente_coordinador: Docente.find(oferta_periodo_params[:docente_coordinador]))
        respond_to do |format|
          if @oferta_periodo.save
            format.html { redirect_to @oferta_periodo, notice: 'Oferta periodo was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_periodo_academico_oferta_periodo_url(@oferta_periodo.periodo_academico_id, @oferta_periodo) }
          else
            format.html { render :new }
            format.json { render json: @oferta_periodo.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /ofertas_periodo/1
      # PATCH/PUT /ofertas_periodo/1.json
      def update
        respond_to do |format|
          if @oferta_periodo.update(oferta_periodo_params)
            format.html { redirect_to @oferta_periodo, notice: 'Oferta periodo was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_periodo_academico_oferta_periodo_url(@oferta_periodo.periodo_academico_id, @oferta_periodo) }
          else
            format.html { render :edit }
            format.json { render json: @oferta_periodo.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /ofertas_periodo/1
      # DELETE /ofertas_periodo/1.json
      def destroy
        @oferta_periodo.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_ofertas_periodo_url, notice: 'Oferta periodo was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_oferta_periodo
          @oferta_periodo = OfertaPeriodo.find(params[:id])
        end
        
        def set_periodo_academico
          @periodo_academico = PeriodoAcademico.find(params[:periodo_academico_id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def oferta_periodo_params
          params.require(:oferta_periodo).permit(:materia_id, :periodo_academico_id, :docente_coordinador)
        end
    end
  end
end
