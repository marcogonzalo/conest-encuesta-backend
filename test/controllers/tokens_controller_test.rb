require 'test_helper'

class Api::V1::TokensControllerTest < ActionController::TestCase
  setup do
    @token = tokens(:token_1)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:tokens)
  end

  test "should create token" do
    assert_difference('Token.count') do
      post :create, token: { hash_sum: @token.hash_sum, token: @token.token }, format: :json
    end

    assert_response 201
  end

  test "should show token" do
    get :show, id: @token, format: :json
    assert_response :success
  end

  test "should update token" do
    patch :update, id: @token, token: { hash_sum: @token.hash_sum, token: @token.token }, format: :json
    assert_response 200
  end

  test "should destroy token" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Token.count', -1) do
      delete :destroy, id: @token, format: :json
    end

    assert_response 204
  end
end
