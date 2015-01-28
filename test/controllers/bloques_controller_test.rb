require 'test_helper'

class BloquesControllerTest < ActionController::TestCase
  setup do
    @bloque = bloques(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bloques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bloque" do
    assert_difference('Bloque.count') do
      post :create, bloque: { descripcion: @bloque.descripcion, nombre: @bloque.nombre, tipo: @bloque.tipo }
    end

    assert_redirected_to bloque_path(assigns(:bloque))
  end

  test "should show bloque" do
    get :show, id: @bloque
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bloque
    assert_response :success
  end

  test "should update bloque" do
    patch :update, id: @bloque, bloque: { descripcion: @bloque.descripcion, nombre: @bloque.nombre, tipo: @bloque.tipo }
    assert_redirected_to bloque_path(assigns(:bloque))
  end

  test "should destroy bloque" do
    assert_difference('Bloque.count', -1) do
      delete :destroy, id: @bloque
    end

    assert_redirected_to bloques_path
  end
end
