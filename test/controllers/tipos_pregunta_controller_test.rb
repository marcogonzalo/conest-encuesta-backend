require 'test_helper'

class Api::V1::TiposPreguntaControllerTest < ActionController::TestCase
  setup do
    @tipo_pregunta = tipos_pregunta(:tipo_pregunta_1)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:tipos_pregunta)
  end

  test "should create tipo_pregunta" do
    assert_difference('TipoPregunta.count') do
      post :create, tipo_pregunta: { nombre: @tipo_pregunta.nombre, valor: @tipo_pregunta.valor, valor_html: @tipo_pregunta.valor_html }, format: :json
    end

    assert_response 201
  end

  test "should show tipo_pregunta" do
    get :show, id: @tipo_pregunta, format: :json
    assert_response :success
  end

  test "should update tipo_pregunta" do
    patch :update, id: @tipo_pregunta, tipo_pregunta: { nombre: @tipo_pregunta.nombre, valor: @tipo_pregunta.valor, valor_html: @tipo_pregunta.valor_html }, format: :json
    assert_response 200
  end

  test "should destroy tipo_pregunta" do
    assert_difference('TipoPregunta.count', -1) do
      delete :destroy, id: @tipo_pregunta, format: :json
    end

    assert_response 204
  end
end
