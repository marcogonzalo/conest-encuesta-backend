require 'test_helper'

class Api::V1::OfertasPeriodoControllerTest < ActionController::TestCase
  setup do
    @oferta_periodo = ofertas_periodo(:one)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:ofertas_periodo)
  end

  test "should create oferta_periodo" do
    assert_difference('OfertaPeriodo.count') do
      post :create, oferta_periodo: { docente_coordinador: @oferta_periodo.docente_coordinador, materia_id: @oferta_periodo.materia_id, periodo_academico_id: @oferta_periodo.periodo_academico_id }, format: :json
    end

    assert_response 201
  end

  test "should show oferta_periodo" do
    get :show, id: @oferta_periodo, format: :json
    assert_response :success
  end

  test "should update oferta_periodo" do
    patch :update, id: @oferta_periodo, oferta_periodo: { docente_coordinador: @oferta_periodo.docente_coordinador, materia_id: @oferta_periodo.materia_id, periodo_academico_id: @oferta_periodo.periodo_academico_id }, format: :json
    assert_response 200
  end

  test "should destroy oferta_periodo" do
    assert_difference('OfertaPeriodo.count', -1) do
      delete :destroy, id: @oferta_periodo, format: :json
    end

    assert_response 204
  end
end
