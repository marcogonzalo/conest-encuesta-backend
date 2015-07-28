require 'test_helper'

class Api::V1::PreguntasControllerTest < ActionController::TestCase
  setup do
    @pregunta = preguntas(:pregunta_1)

    @usuario = FactoryGirl.create(:usuario_superadmin)
    request.headers['Authorization'] = "Bearer " + @usuario.token.to_s 
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:preguntas)
  end

  test "should create pregunta" do
    assert_difference('Pregunta.count') do
      post :create, pregunta: { descripcion: @pregunta.descripcion, interrogante: @pregunta.interrogante, tipo_pregunta_id: @pregunta.tipo_pregunta_id }, format: :json
    end

    assert_response 201
  end

  test "should show pregunta" do
    get :show, id: @pregunta, format: :json
    assert_response :success
  end

  test "should update pregunta" do
    patch :update, id: @pregunta, pregunta: { descripcion: @pregunta.descripcion, interrogante: @pregunta.interrogante, tipo_pregunta_id: @pregunta.tipo_pregunta_id }, format: :json
    assert_response 200
  end

  test "should destroy pregunta" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Pregunta.count', -1) do
      delete :destroy, id: @pregunta, format: :json
    end

    assert_response 204
  end
end
