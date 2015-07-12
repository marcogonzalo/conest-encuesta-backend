module Api
  module V1
    class EstudiantesController < ApplicationController
      before_action :set_estudiante, only: [:show, :update, :destroy]
      before_action :set_estudiante_by_cedula, only: [:consultas_sin_responder]

      # GET /estudiantes
      # GET /estudiantes.json
      def index
        @estudiantes = Estudiante.all
      end

      # GET /estudiantes/1
      # GET /estudiantes/1.json
      def show
      end

      # POST /estudiantes
      # POST /estudiantes.json
      def create
        @estudiante = Estudiante.new(estudiante_params)

        respond_to do |format|
          if @estudiante.save
            format.html { redirect_to @estudiante, notice: 'Estudiante was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_estudiante_url(@estudiante) }
          else
            format.html { render :new }
            format.json { render json: @estudiante.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /estudiantes/1
      # PATCH/PUT /estudiantes/1.json
      def update
        respond_to do |format|
          if @estudiante.update(estudiante_params)
            format.html { redirect_to @estudiante, notice: 'Estudiante was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_estudiante_url(@estudiante) }
          else
            format.html { render :edit }
            format.json { render json: @estudiante.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /estudiantes/1
      # DELETE /estudiantes/1.json
      def destroy
        @estudiante.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_estudiantes_url, notice: 'Estudiante was successfully destroyed.' }
          format.json { head :no_content }
        end
      end
      
      def consultas_sin_responder
        if @estudiante
          @consultas_sin_responder = @estudiante.oferta_academica.sin_responder_consulta.includes(oferta_periodo: [:periodo_academico, :materia])
        else
          render json: { estatus: "ERROR", mensaje: "La cédula no coincide con ningún estudiante" }, status: :not_found
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_estudiante
          @estudiante = Estudiante.find(params[:id])
        end

        def set_estudiante_by_cedula
          puts params[:id]
          puts Estudiante.all.inspect
          @estudiante = Estudiante.find_by(cedula: params[:id])
          puts @estudiante
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def estudiante_params
          params.require(:estudiante).permit(:cedula, :primer_nombre, :segundo_nombre, :primer_apellido, :segundo_apellido)
        end
    end
  end
end
