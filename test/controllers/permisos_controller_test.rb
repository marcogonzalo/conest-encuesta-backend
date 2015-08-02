require 'test_helper'

class Api::V1::PermisosControllerTest < ActionController::TestCase
  setup do
    @usuario = FactoryGirl.create(:usuario_admin)
    request.headers['Authorization'] = "Bearer " + @usuario.token.to_s 
  end

  test "debe indicar true si el rol tiene el permiso indicado" do
      get :puede, nombre_permiso: @usuario.rol.permisos.last.nombre, format: :json
      assert_response :success

      respuesta = JSON.parse(@response.body)
      assert_equal true, respuesta['puede']
  end

  test "debe indicar false si el rol no tiene el permiso indicado" do
      get :puede, nombre_permiso: "otracosa", format: :json
      assert_response :success
      
      respuesta = JSON.parse(@response.body)
      assert_equal false, respuesta['puede']
  end

end
