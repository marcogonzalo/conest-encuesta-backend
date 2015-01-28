require 'test_helper'

class TiposPreguntaControllerTest < ActionController::TestCase
  setup do
    @tipo_pregunta = tipos_pregunta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipos_pregunta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_pregunta" do
    assert_difference('TipoPregunta.count') do
      post :create, tipo_pregunta: { nombre: @tipo_pregunta.nombre, valor: @tipo_pregunta.valor, valor_html: @tipo_pregunta.valor_html }
    end

    assert_redirected_to tipo_pregunta_path(assigns(:tipo_pregunta))
  end

  test "should show tipo_pregunta" do
    get :show, id: @tipo_pregunta
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_pregunta
    assert_response :success
  end

  test "should update tipo_pregunta" do
    patch :update, id: @tipo_pregunta, tipo_pregunta: { nombre: @tipo_pregunta.nombre, valor: @tipo_pregunta.valor, valor_html: @tipo_pregunta.valor_html }
    assert_redirected_to tipo_pregunta_path(assigns(:tipo_pregunta))
  end

  test "should destroy tipo_pregunta" do
    assert_difference('TipoPregunta.count', -1) do
      delete :destroy, id: @tipo_pregunta
    end

    assert_redirected_to tipos_pregunta_path
  end
end
