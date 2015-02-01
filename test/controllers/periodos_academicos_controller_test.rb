require 'test_helper'

class Api::V1::PeriodosAcademicosControllerTest < ActionController::TestCase
  setup do
    @periodo_academico = periodos_academicos(:one)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:periodos_academicos)
  end

  test "should create periodo_academico" do
    assert_difference('PeriodoAcademico.count') do
      post :create, periodo_academico: { hash_sum: @periodo_academico.hash_sum, periodo: @periodo_academico.periodo, sincronizacion: @periodo_academico.sincronizacion }, format: :json
    end

    assert_response 201
  end

  test "should show periodo_academico" do
    get :show, id: @periodo_academico, format: :json
    assert_response :success
  end

  test "should update periodo_academico" do
    patch :update, id: @periodo_academico, periodo_academico: { hash_sum: @periodo_academico.hash_sum, periodo: @periodo_academico.periodo, sincronizacion: @periodo_academico.sincronizacion }, format: :json
    assert_response 200
  end

  test "should destroy periodo_academico" do
    assert_difference('PeriodoAcademico.count', -1) do
      delete :destroy, id: @periodo_academico, format: :json
    end

    assert_response 204
  end
end
