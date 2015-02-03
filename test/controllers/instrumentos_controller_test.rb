require 'test_helper'

class Api::V1::InstrumentosControllerTest < ActionController::TestCase
  setup do
    @instrumento = instrumentos(:instrumento_1)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:instrumentos)
  end

  test "should create instrumento" do
    assert_difference('Instrumento.count') do
      post :create, instrumento: { descripcion: @instrumento.descripcion, nombre: @instrumento.nombre }, format: :json
    end

    assert_response 201
  end

  test "should show instrumento" do
    get :show, id: @instrumento, format: :json
    assert_response :success
  end

  test "should update instrumento" do
    patch :update, id: @instrumento, instrumento: { descripcion: @instrumento.descripcion, nombre: @instrumento.nombre }, format: :json
    assert_response 200
  end

  test "should destroy instrumento" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Instrumento.count', -1) do
      delete :destroy, id: @instrumento, format: :json
    end

    assert_response 204
  end
end
