require 'test_helper'

class Api::V1::ConsultasControllerTest < ActionController::TestCase
  setup do
    @consulta = consultas(:consulta_1)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:consultas)
  end

  test "should create consulta" do
    assert_difference('Consulta.count') do
      post :create, consulta: { instrumento_id: @consulta.instrumento_id, oferta_academica_id: @consulta.oferta_academica_id }, format: :json
    end

    assert_response 201
  end

  test "should show consulta" do
    get :show, id: @consulta, format: :json
    assert_response :success
  end

  test "should update consulta" do
    patch :update, id: @consulta, consulta: { instrumento_id: @consulta.instrumento_id, oferta_academica_id: @consulta.oferta_academica_id }, format: :json
    assert_response 200
  end

  test "should destroy consulta" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Consulta.count', -1) do
      delete :destroy, id: @consulta, format: :json
    end

    assert_response 204
  end
end
