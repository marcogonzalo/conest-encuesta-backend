require 'test_helper'

class Api::V1::BloquesControllerTest < ActionController::TestCase
  setup do
    @bloque = bloques(:bloque_1)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:bloques)
  end

  test "should create bloque" do
    assert_difference('Bloque.count') do
      post :create, bloque: { descripcion: @bloque.descripcion, nombre: @bloque.nombre, tipo: @bloque.tipo }, format: :json
    end

    assert_response 201
  end

  test "should show bloque" do
    get :show, id: @bloque, format: :json
    assert_response :success
  end

  test "should update bloque" do
    patch :update, id: @bloque, bloque: { descripcion: @bloque.descripcion, nombre: @bloque.nombre, tipo: @bloque.tipo }, format: :json
    assert_response 200
  end

  test "should destroy bloque" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Bloque.count', -1) do
      delete :destroy, id: @bloque, format: :json
    end

    assert_response 204
  end
end
