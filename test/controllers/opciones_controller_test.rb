require 'test_helper'

class Api::V1::OpcionesControllerTest < ActionController::TestCase
  setup do
    @opcion = FactoryGirl.create(:opcion)
    @pregunta = FactoryGirl.create(:pregunta)

    @usuario = FactoryGirl.create(:usuario_superadmin)
    request.headers['Authorization'] = "Bearer " + @usuario.token.to_s 
  end

  test "should get index" do
    get :index, pregunta_id: @pregunta.id, format: :json
    assert_response :success
    assert_not_nil assigns(:opciones)
  end

  test "should create opcion" do
    opcion = FactoryGirl.build(:opcion)
    assert_difference('Opcion.count') do
      post :create, pregunta_id: @pregunta.id, opcion: { etiqueta: opcion.etiqueta, pregunta_id: @pregunta.id, valor: opcion.valor }, format: :json
    end

    assert_response 201
  end

  test "should show opcion" do
    get :show, pregunta_id: @pregunta.id, id: @opcion, format: :json
    assert_response :success
  end

  test "should update opcion" do
    patch :update, pregunta_id: @pregunta.id, id: @opcion, opcion: { etiqueta: @opcion.etiqueta, pregunta_id: @opcion.pregunta_id, valor: @opcion.valor }, format: :json
    assert_response 200
  end

  test "should destroy opcion" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Opcion.count', -1) do
      delete :destroy, id: @opcion, format: :json
    end

    assert_response 204
  end
end
