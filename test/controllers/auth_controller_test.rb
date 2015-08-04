require 'test_helper'

class Api::V1::AuthControllerTest < ActionController::TestCase
  setup do
    @usuario = FactoryGirl.create(:usuario)
  end

  test "should get authenticate" do
    post :authenticate, { cedula: @usuario.cedula, clave: @usuario.clave }
    assert_response :success
  end

end
