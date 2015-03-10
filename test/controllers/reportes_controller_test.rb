require 'test_helper'

class Api::V1::ReportesControllerTest < ActionController::TestCase
	setup do
    @respuesta = FactoryGirl.create(:respuesta)
	end

  test "debería mostrarme un reporte histórico de una pregunta en json" do
    get :reporte_historico_materia_pregunta, tipo_reporte: 'historico_pregunta', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, pregunta_id: @respuesta.pregunta_id, format: :json
    assert_response :success
  end

  test "debería mostrarme un reporte histórico según un instrumento en json" do
    get :reporte_historico_materia_completo, tipo_reporte: 'historico_completo', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, instrumento_id: @respuesta.consulta.instrumento_id, format: :json
    assert_response :success
  end

  test "debería mostrarme un reporte comparado entre preguntas de un instrumento en json" do
    get :reporte_historico_materia_comparado, tipo_reporte: 'historico_comparado', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, instrumento_id: @respuesta.consulta.instrumento_id, ids: [@respuesta.pregunta_id], format: :json
    assert_response :success
  end
end
