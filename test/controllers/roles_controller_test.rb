require 'test_helper'

class Api::V1::RolesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @rol = FactoryGirl.create(:rol)
    @permiso = FactoryGirl.create(:permiso)

    @usuario = FactoryGirl.create(:usuario_superadmin)
    request.headers['Authorization'] = "Bearer " + @usuario.token.to_s 
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test "should show rol" do
    get :show, id: Rol.find_by(nombre: @rol.nombre), format: :json
    assert_response :success
  end

  test "should update rol" do
      antes = @rol.permisos.count
      patch :update, id: @rol.id, permisos: [@permiso], format: :json
      assert_response :success
      despues = @rol.permisos.count
      assert_not_equal antes, despues 
  end

  test "deberia actualizar un permiso de rol una sola vez" do
      antes = @rol.permisos.count
      patch :update, id: @rol.id, permisos: [@permiso], format: :json
      assert_response :success
      despues_1 = @rol.permisos.count
      assert_not_equal antes, despues_1 
 
      patch :update, id: @rol.id, permisos: [@permiso], format: :json
      despues_2 = @rol.permisos.count

      puts @rol.permisos.inspect

      assert_equal despues_1, despues_2 
  end

end
