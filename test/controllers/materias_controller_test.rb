require 'test_helper'

class Api::V1::MateriasControllerTest < ActionController::TestCase
  setup do
    @materia = materias(:one)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:materias)
  end

  test "should create materia" do
    assert_difference('Materia.count') do
      post :create, materia: { carrera_id: @materia.carrera_id, codigo: @materia.codigo, grupo_nota_id: @materia.grupo_nota_id, nombre: @materia.nombre, plan_nombre: @materia.plan_nombre, tipo_materia_id: @materia.tipo_materia_id }, format: :json
    end

    assert_response 201
  end

  test "should show materia" do
    get :show, id: @materia, format: :json
    assert_response :success
  end

  test "should update materia" do
    patch :update, id: @materia, materia: { carrera_id: @materia.carrera_id, codigo: @materia.codigo, grupo_nota_id: @materia.grupo_nota_id, nombre: @materia.nombre, plan_nombre: @materia.plan_nombre, tipo_materia_id: @materia.tipo_materia_id }, format: :json
    assert_response 200
  end

  test "should destroy materia" do
    assert_difference('Materia.count', -1) do
      delete :destroy, id: @materia, format: :json
    end

    assert_response 204
  end
end
