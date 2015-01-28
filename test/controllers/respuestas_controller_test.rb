require 'test_helper'

class RespuestasControllerTest < ActionController::TestCase
  setup do
    @respuesta = respuestas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:respuestas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create respuesta" do
    assert_difference('Respuesta.count') do
      post :create, respuesta: { consulta_id: @respuesta.consulta_id, pregunta_id: @respuesta.pregunta_id, valor: @respuesta.valor }
    end

    assert_redirected_to respuesta_path(assigns(:respuesta))
  end

  test "should show respuesta" do
    get :show, id: @respuesta
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @respuesta
    assert_response :success
  end

  test "should update respuesta" do
    patch :update, id: @respuesta, respuesta: { consulta_id: @respuesta.consulta_id, pregunta_id: @respuesta.pregunta_id, valor: @respuesta.valor }
    assert_redirected_to respuesta_path(assigns(:respuesta))
  end

  test "should destroy respuesta" do
    assert_difference('Respuesta.count', -1) do
      delete :destroy, id: @respuesta
    end

    assert_redirected_to respuestas_path
  end
end
