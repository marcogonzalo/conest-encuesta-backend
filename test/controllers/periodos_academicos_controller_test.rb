require 'test_helper'

class PeriodosAcademicosControllerTest < ActionController::TestCase
  setup do
    @periodo_academico = periodos_academicos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:periodos_academicos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create periodo_academico" do
    assert_difference('PeriodoAcademico.count') do
      post :create, periodo_academico: { hash_sum: @periodo_academico.hash_sum, periodo: @periodo_academico.periodo, sincronizacion: @periodo_academico.sincronizacion }
    end

    assert_redirected_to periodo_academico_path(assigns(:periodo_academico))
  end

  test "should show periodo_academico" do
    get :show, id: @periodo_academico
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @periodo_academico
    assert_response :success
  end

  test "should update periodo_academico" do
    patch :update, id: @periodo_academico, periodo_academico: { hash_sum: @periodo_academico.hash_sum, periodo: @periodo_academico.periodo, sincronizacion: @periodo_academico.sincronizacion }
    assert_redirected_to periodo_academico_path(assigns(:periodo_academico))
  end

  test "should destroy periodo_academico" do
    assert_difference('PeriodoAcademico.count', -1) do
      delete :destroy, id: @periodo_academico
    end

    assert_redirected_to periodos_academicos_path
  end
end
