require 'test_helper'

class Api::V1::DocentesControllerTest < ActionController::TestCase
  setup do
    @docente = FactoryGirl.create(:docente)

    @usuario = FactoryGirl.create(:usuario_superadmin)
    request.headers['Authorization'] = "Bearer " + @usuario.token.to_s 
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:docentes)
  end

  test "should create docente" do
    docente = FactoryGirl.build(:docente)
    assert_difference('Docente.count') do
      post :create, docente: { cedula: docente.cedula, primer_apellido: docente.primer_apellido, primer_nombre: docente.primer_nombre, segundo_apellido: docente.segundo_apellido, segundo_nombre: docente.segundo_nombre }, format: :json
    end

    assert_response 201
  end

  test "should show docente" do
    get :show, id: @docente, format: :json
    assert_response :success
  end

  test "should update docente" do
    patch :update, id: @docente, docente: { cedula: @docente.cedula, primer_apellido: @docente.primer_apellido, primer_nombre: @docente.primer_nombre, segundo_apellido: @docente.segundo_apellido, segundo_nombre: @docente.segundo_nombre }, format: :json
    assert_response 200
  end

  test "should destroy docente" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Docente.count', -1) do
      delete :destroy, id: @docente, format: :json
    end

    assert_response 204
  end
end
