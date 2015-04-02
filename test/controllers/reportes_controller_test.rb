require 'test_helper'

class Api::V1::ReportesControllerTest < ActionController::TestCase
	setup do
    @respuesta = FactoryGirl.create(:respuesta)
  end

  test "debería mostrarme un reporte histórico de una pregunta para una materia en json" do
    get :reporte_historico_pregunta_de_materia, tipo_reporte: 'historico_pregunta', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, pregunta_id: @respuesta.pregunta_id, format: :json
    assert_response :success
  end

  test "no debería mostrarme un reporte histórico de una pregunta para una materia si el código de la materia es incorrecto" do
    get :reporte_historico_pregunta_de_materia, tipo_reporte: 'historico_pregunta', codigo_materia: 0000, pregunta_id: @respuesta.pregunta_id, format: :json
    assert_response :not_found
  end

  test "no debería mostrarme un reporte histórico de una pregunta para una materia en json si la pregunta no existe" do
    get :reporte_historico_pregunta_de_materia, tipo_reporte: 'historico_pregunta', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, pregunta_id: 14365468, format: :json
    assert_response :not_found
  end

  test "debería mostrarme un reporte comparado entre preguntas de un instrumento en json" do
    @materia = FactoryGirl.create(:materia)
    @pregunta = FactoryGirl.create(:pregunta_en_bloques)
    get :reporte_historico_comparado_de_materia, tipo_reporte: 'historico_comparado', codigo_materia: @materia.codigo, instrumento_id: @pregunta.bloques.first.instrumentos.first.id, ids: [@pregunta.id], format: :json
    assert_response :success
  end

  test "no debería mostrarme un reporte comparado entre preguntas de un instrumento si el código de la materia es incorrecto" do
    get :reporte_historico_comparado_de_materia, tipo_reporte: 'historico_comparado', codigo_materia: 0000, instrumento_id: @respuesta.consulta.instrumento_id, ids: [@respuesta.pregunta_id], format: :json
    assert_response :not_found
  end

  test "no debería mostrarme un reporte comparado entre preguntas si el instrumento no existe" do
    get :reporte_historico_comparado_de_materia, tipo_reporte: 'historico_comparado', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, instrumento_id: 321324, ids: [@respuesta.pregunta_id], format: :json
    assert_response :not_found
  end

  test "no debería mostrarme un reporte comparado de un instrumento si las preguntas no existen" do
    get :reporte_historico_comparado_de_materia, tipo_reporte: 'historico_comparado', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, instrumento_id: @respuesta.consulta.instrumento_id, ids: [0,2], format: :json
    assert_response :not_found
  end

  test "debería mostrarme un reporte histórico según un instrumento en json" do
    @materia = FactoryGirl.create(:materia)
    @pregunta = FactoryGirl.create(:pregunta_en_bloques)
    get :reporte_historico_completo_de_materia, tipo_reporte: 'historico_completo', codigo_materia: @materia.codigo, instrumento_id: @pregunta.bloques.first.instrumentos.first.id, format: :json
    assert_response :success
  end

  test "no debería mostrarme un reporte histórico según un instrumento si la materia no existe" do
    get :reporte_historico_completo_de_materia, tipo_reporte: 'historico_completo', codigo_materia: 0000, instrumento_id: @respuesta.consulta.instrumento_id, format: :json
    assert_response :not_found
  end

  test "no debería mostrarme un reporte histórico según un instrumento si el instrumento no existe" do
    get :reporte_historico_completo_de_materia, tipo_reporte: 'historico_completo', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, instrumento_id: 4365327, format: :json
    assert_response :not_found
  end

  test "debería mostrarme un reporte comparado del período entre preguntas de un instrumento en json" do
    get :reporte_periodo_comparado_de_materia, tipo_reporte: 'periodo_comparado', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, periodo: @respuesta.consulta.oferta_academica.oferta_periodo.periodo_academico.periodo, ids: [@respuesta.pregunta_id], format: :json
    assert_response :success
  end

  test "no debería mostrarme un reporte comparado según un instrumento si la materia no existe" do
    get :reporte_periodo_comparado_de_materia, tipo_reporte: 'periodo_comparado', codigo_materia: 0000, periodo: @respuesta.consulta.oferta_academica.oferta_periodo.periodo_academico.periodo, ids: [@respuesta.pregunta_id], format: :json
    assert_response :not_found
  end

  test "no debería mostrarme un reporte comparado según un instrumento si el periodo no existe" do
    get :reporte_periodo_comparado_de_materia, tipo_reporte: 'periodo_comparado', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, periodo: "01-2000", ids: [@respuesta.pregunta_id], format: :json
    assert_response :not_found
  end

  test "debería mostrarme un reporte del período según un instrumento en json" do
    get :reporte_periodo_completo_de_materia, tipo_reporte: 'periodo_completo', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, periodo: @respuesta.consulta.oferta_academica.oferta_periodo.periodo_academico.periodo, format: :json
    assert_response :success
  end

  test "no debería mostrarme un reporte del período según un instrumento en json si el código de la materia es incorrecto" do
    get :reporte_periodo_completo_de_materia, tipo_reporte: 'periodo_completo', codigo_materia: 0000, periodo: @respuesta.consulta.oferta_academica.oferta_periodo.periodo_academico.periodo, format: :json
    assert_response :not_found
  end

  test "no debería mostrarme un reporte del período según un instrumento en json si el período es incorrecto" do
    get :reporte_periodo_completo_de_materia, tipo_reporte: 'periodo_completo', codigo_materia: @respuesta.consulta.oferta_academica.oferta_periodo.materia.codigo, periodo: "01-2000", format: :json
    assert_response :not_found
  end
end
