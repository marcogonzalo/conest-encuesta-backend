require 'test_helper'

class Api::V1::CarrerasControllerTest < ActionController::TestCase
  setup do
    @carrera = carreras(:one)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:carreras)
  end

  test "should create carrera" do
    assert_difference('Carrera.count') do
      post :create, carrera: { codigo: @carrera.codigo, nombre: @carrera.nombre, organizacion_id: @carrera.organizacion_id }, format: :json
    end

    assert_response 201
  end

  test "should show carrera" do
    get :show, id: @carrera, format: :json
    assert_response :success
  end

  test "should update carrera" do
    patch :update, id: @carrera, carrera: { codigo: @carrera.codigo, nombre: @carrera.nombre, organizacion_id: @carrera.organizacion_id }, format: :json
    assert_response 200
  end

  test "should destroy carrera" do
    assert_difference('Carrera.count', -1) do
      delete :destroy, id: @carrera, format: :json
    end

    assert_response 204
  end
end
