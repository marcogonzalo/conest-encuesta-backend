require 'test_helper'

class CarrerasControllerTest < ActionController::TestCase
  setup do
    @carrera = carreras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carreras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create carrera" do
    assert_difference('Carrera.count') do
      post :create, carrera: { codigo: @carrera.codigo, nombre: @carrera.nombre, organizacion_id: @carrera.organizacion_id }
    end

    assert_redirected_to carrera_path(assigns(:carrera))
  end

  test "should show carrera" do
    get :show, id: @carrera
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @carrera
    assert_response :success
  end

  test "should update carrera" do
    patch :update, id: @carrera, carrera: { codigo: @carrera.codigo, nombre: @carrera.nombre, organizacion_id: @carrera.organizacion_id }
    assert_redirected_to carrera_path(assigns(:carrera))
  end

  test "should destroy carrera" do
    assert_difference('Carrera.count', -1) do
      delete :destroy, id: @carrera
    end

    assert_redirected_to carreras_path
  end
end
