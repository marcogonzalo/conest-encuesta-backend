module Api
  module V1
    class PeriodosAcademicosController < ApplicationController
      before_action :set_periodo_academico, only: [:show, :edit, :update, :destroy]

      # GET /periodos_academicos
      # GET /periodos_academicos.json
      def index
        @periodos_academicos = PeriodoAcademico.all
      end

      # GET /periodos_academicos/1
      # GET /periodos_academicos/1.json
      def show
      end

      # GET /periodos_academicos/new
      def new
        @periodo_academico = PeriodoAcademico.new
      end

      # GET /periodos_academicos/1/edit
      def edit
      end

      # POST /periodos_academicos
      # POST /periodos_academicos.json
      def create
          periodo_academico_id = periodo_academico_params[:periodo]
          response = RestClient.get "#{CONEST_API[:base_url]}/asignaturas_en_periodo_academico/#{periodo_academico_id}",
                      :conest_token  => Token::actual
          r = JSON.parse(response.body)
          if r['estatus'] == 'OK'
            d = r['datos']
            @periodo_academico = PeriodoAcademico.new(periodo: d['periodo_academico_id'], hash_sum: r['sha1_sum'], sincronizacion: r['fecha_hora'])
            @periodo_academico.save
            d['organizaciones'].each do |o|
              o['carreras'].each do |c|
                @carrera = Carrera.new(codigo: c['id'], nombre: c['nombre'], organizacion_id: o['id'])
                @carrera.save
                c['materias'].each do |m|
                  @materia = Materia.new(carrera: @carrera, plan_nombre: c['plan_nombre'], codigo: m['codigo'], nombre: m['nombre'], tipo_materia_id: m['tipo_materia_id'], grupo_nota_id: m['grupo_nota_id'])
                  @materia.save
                end
              end
            end
          end
        respond_to do |format|
          if @carrera.save
            format.html { redirect_to @periodo_academico, notice: 'Periodo academico was successfully created.' }
            format.json { render :show, status: :created, location: api_v1_periodo_academico_url(@periodo_academico) }
          else
            format.html { render :new }
            format.json { render json: @periodo_academico.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /periodos_academicos/1
      # PATCH/PUT /periodos_academicos/1.json
      def update
        respond_to do |format|
          if @periodo_academico.update(periodo_academico_params)
            format.html { redirect_to @periodo_academico, notice: 'Periodo academico was successfully updated.' }
            format.json { render :show, status: :ok, location: api_v1_periodo_academico_url(@periodo_academico) }
          else
            format.html { render :edit }
            format.json { render json: @periodo_academico.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /periodos_academicos/1
      # DELETE /periodos_academicos/1.json
      def destroy
        @periodo_academico.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_periodos_academicos_url, notice: 'Periodo academico was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_periodo_academico
          @periodo_academico = PeriodoAcademico.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def periodo_academico_params
          params.require(:periodo_academico).permit(:periodo, :hash_sum, :sincronizacion)
        end
    end
  end
end
