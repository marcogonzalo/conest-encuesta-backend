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
    @periodo_academico = PeriodoAcademico.new(periodo_academico_params)

    respond_to do |format|
      if @periodo_academico.save
        format.html { redirect_to @periodo_academico, notice: 'Periodo academico was successfully created.' }
        format.json { render :show, status: :created, location: @periodo_academico }
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
        format.json { render :show, status: :ok, location: @periodo_academico }
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
      format.html { redirect_to periodos_academicos_url, notice: 'Periodo academico was successfully destroyed.' }
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
