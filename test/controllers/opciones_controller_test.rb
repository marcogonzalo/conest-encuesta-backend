require 'test_helper'

class OpcionesControllerTest < ActionController::TestCase
  setup do
    @opcion = opciones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:opciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create opcion" do
    assert_difference('Opcion.count') do
      post :create, opcion: { etiqueta: @opcion.etiqueta, pregunta_id: @opcion.pregunta_id, valor: @opcion.valor }
    end

    assert_redirected_to opcion_path(assigns(:opcion))
  end

  test "should show opcion" do
    get :show, id: @opcion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @opcion
    assert_response :success
  end

  test "should update opcion" do
    patch :update, id: @opcion, opcion: { etiqueta: @opcion.etiqueta, pregunta_id: @opcion.pregunta_id, valor: @opcion.valor }
    assert_redirected_to opcion_path(assigns(:opcion))
  end

  test "should destroy opcion" do
    assert_difference('Opcion.count', -1) do
      delete :destroy, id: @opcion
    end

    assert_redirected_to opciones_path
  end
end
