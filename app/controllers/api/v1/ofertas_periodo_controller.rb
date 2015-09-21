module Api
  module V1
    class OfertasPeriodoController < ApplicationController
      load_and_authorize_resource
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
            format.json { render :show, status: :created, location: api_v1_oferta_periodo_url(@oferta_periodo.periodo_academico_id, @oferta_periodo) }
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
            format.json { render :show, status: :ok, location: api_v1_oferta_periodo_url(@oferta_periodo.periodo_academico_id, @oferta_periodo) }
          else
            format.html { render :edit }
            format.json { render json: @oferta_periodo.errors, status: :unprocessable_entity }
          end
        end
      end


      # PATCH/PUT /consultas/1
      # PATCH/PUT /consultas/1.json
      def cambiar_instrumento
        @oferta_periodo = OfertaPeriodo.includes(oferta_academica: [:consulta]).find(cambio_instrumento_params[:id])

        # Falta PU
        # Falta verificar existencia de respuestas
        # Falta cambio
        instrumento = Instrumento.find(cambio_instrumento_params[:instrumento_id])

        existen_respuestas = false

        # Se verifica si ninguna seccion ha recibido respuesta a su consulta
        @oferta_periodo.oferta_academica.each do |seccion|
          unless seccion.consulta.respuestas.size > 0
            existen_respuestas = true
            break
          end
        end

        # Si ninguna seccion ha recibido respuesta, entonces 
        if existen_respuestas
          render json: { error: 'No se puede realizar el cambio. Se encontró al menos una respuesta registrada con el instrumento actual.' }, status: :ok  
        else
          @oferta_periodo.oferta_academica.each do |seccion|
            seccion.consulta.update(instrumento_id: instrumento.id)
          end
          render json: { error: 'Cambio de instrumento satisfactorio' }, status: :ok  
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

        # Parametros para el cambio de un instrumento para una consulta de una materia en un periodo
        def cambio_instrumento_params
          params.permit(:id, :instrumento_id)
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def oferta_periodo_params
          params.require(:oferta_periodo).permit(:materia_id, :periodo_academico_id, :docente_coordinador)
        end
    end
  end
end
