require 'test_helper'

class Api::V1::EstudiantesControllerTest < ActionController::TestCase
  setup do
    @estudiante = estudiantes(:estudiante_1)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:estudiantes)
  end

  test "should create estudiante" do
    assert_difference('Estudiante.count') do
      post :create, estudiante: { cedula: @estudiante.cedula, primer_apellido: @estudiante.primer_apellido, primer_nombre: @estudiante.primer_nombre, segundo_apellido: @estudiante.segundo_apellido, segundo_nombre: @estudiante.segundo_nombre }, format: :json
    end

    assert_response 201
  end

  test "should show estudiante" do
    get :show, id: @estudiante, format: :json
    assert_response :success
  end

  test "should update estudiante" do
    patch :update, id: @estudiante, estudiante: { cedula: @estudiante.cedula, primer_apellido: @estudiante.primer_apellido, primer_nombre: @estudiante.primer_nombre, segundo_apellido: @estudiante.segundo_apellido, segundo_nombre: @estudiante.segundo_nombre }, format: :json
    assert_response 200
  end

  test "should destroy estudiante" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Estudiante.count', -1) do
      delete :destroy, id: @estudiante, format: :json
    end

    assert_response 204
  end
end
