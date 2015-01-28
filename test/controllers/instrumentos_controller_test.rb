require 'test_helper'

class InstrumentosControllerTest < ActionController::TestCase
  setup do
    @instrumento = instrumentos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:instrumentos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create instrumento" do
    assert_difference('Instrumento.count') do
      post :create, instrumento: { descripcion: @instrumento.descripcion, nombre: @instrumento.nombre }
    end

    assert_redirected_to instrumento_path(assigns(:instrumento))
  end

  test "should show instrumento" do
    get :show, id: @instrumento
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @instrumento
    assert_response :success
  end

  test "should update instrumento" do
    patch :update, id: @instrumento, instrumento: { descripcion: @instrumento.descripcion, nombre: @instrumento.nombre }
    assert_redirected_to instrumento_path(assigns(:instrumento))
  end

  test "should destroy instrumento" do
    assert_difference('Instrumento.count', -1) do
      delete :destroy, id: @instrumento
    end

    assert_redirected_to instrumentos_path
  end
end
