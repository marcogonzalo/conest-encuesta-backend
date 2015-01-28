class OfertaAcademicaController < ApplicationController
  before_action :set_oferta_academica, only: [:show, :edit, :update, :destroy]

  # GET /oferta_academica
  # GET /oferta_academica.json
  def index
    @oferta_academica = OfertaAcademica.all
  end

  # GET /oferta_academica/1
  # GET /oferta_academica/1.json
  def show
  end

  # GET /oferta_academica/new
  def new
    @oferta_academica = OfertaAcademica.new
  end

  # GET /oferta_academica/1/edit
  def edit
  end

  # POST /oferta_academica
  # POST /oferta_academica.json
  def create
    @oferta_academica = OfertaAcademica.new(oferta_academica_params)

    respond_to do |format|
      if @oferta_academica.save
        format.html { redirect_to @oferta_academica, notice: 'Oferta academica was successfully created.' }
        format.json { render :show, status: :created, location: @oferta_academica }
      else
        format.html { render :new }
        format.json { render json: @oferta_academica.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /oferta_academica/1
  # PATCH/PUT /oferta_academica/1.json
  def update
    respond_to do |format|
      if @oferta_academica.update(oferta_academica_params)
        format.html { redirect_to @oferta_academica, notice: 'Oferta academica was successfully updated.' }
        format.json { render :show, status: :ok, location: @oferta_academica }
      else
        format.html { render :edit }
        format.json { render json: @oferta_academica.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oferta_academica/1
  # DELETE /oferta_academica/1.json
  def destroy
    @oferta_academica.destroy
    respond_to do |format|
      format.html { redirect_to oferta_academica_index_url, notice: 'Oferta academica was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oferta_academica
      @oferta_academica = OfertaAcademica.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oferta_academica_params
      params.require(:oferta_academica).permit(:oferta_periodo_id, :nombre_seccion, :docente_id, :promedio_general, :nro_estudiantes, :nro_estudiantes_retirados, :nro_estudiantes_aprobados, :nro_estudiantes_equivalencia, :nro_estudiantes_suficiencia, :nro_estudiantes_reparacion, :nro_estudiantes_aplazados, :tipo_estatus_calificacion_id)
    end
end
