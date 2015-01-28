require 'test_helper'

class MateriasControllerTest < ActionController::TestCase
  setup do
    @materia = materias(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:materias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create materia" do
    assert_difference('Materia.count') do
      post :create, materia: { carrera_id: @materia.carrera_id, codigo: @materia.codigo, grupo_nota_id: @materia.grupo_nota_id, nombre: @materia.nombre, plan_nombre: @materia.plan_nombre, tipo_materia_id: @materia.tipo_materia_id }
    end

    assert_redirected_to materia_path(assigns(:materia))
  end

  test "should show materia" do
    get :show, id: @materia
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @materia
    assert_response :success
  end

  test "should update materia" do
    patch :update, id: @materia, materia: { carrera_id: @materia.carrera_id, codigo: @materia.codigo, grupo_nota_id: @materia.grupo_nota_id, nombre: @materia.nombre, plan_nombre: @materia.plan_nombre, tipo_materia_id: @materia.tipo_materia_id }
    assert_redirected_to materia_path(assigns(:materia))
  end

  test "should destroy materia" do
    assert_difference('Materia.count', -1) do
      delete :destroy, id: @materia
    end

    assert_redirected_to materias_path
  end
end
