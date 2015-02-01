require 'test_helper'

class Api::V1::OpcionesControllerTest < ActionController::TestCase
  setup do
    @opcion = opciones(:one)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:opciones)
  end

  test "should create opcion" do
    assert_difference('Opcion.count') do
      post :create, opcion: { etiqueta: @opcion.etiqueta, pregunta_id: @opcion.pregunta_id, valor: @opcion.valor }, format: :json
    end

    assert_response 201
  end

  test "should show opcion" do
    get :show, id: @opcion, format: :json
    assert_response :success
  end

  test "should update opcion" do
    patch :update, id: @opcion, opcion: { etiqueta: @opcion.etiqueta, pregunta_id: @opcion.pregunta_id, valor: @opcion.valor }, format: :json
    assert_response 200
  end

  test "should destroy opcion" do
    assert_difference('Opcion.count', -1) do
      delete :destroy, id: @opcion, format: :json
    end

    assert_response 204
  end
end
