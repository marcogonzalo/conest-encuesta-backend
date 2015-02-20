require 'test_helper'

class Api::V1::ReportesControllerTest < ActionController::TestCase
	setup do
    @respuesta = FactoryGirl.create(:respuesta)
	end

  test "debería mostrarme un reporte sencillo en json" do
    get :controlador, tipo_reporte: 'sencillo', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, pregunta_id: @respuesta.pregunta_id, format: :json
    assert_response :success
  end
end
