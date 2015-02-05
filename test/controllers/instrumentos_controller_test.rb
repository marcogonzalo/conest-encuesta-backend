require 'test_helper'

class Api::V1::InstrumentosControllerTest < ActionController::TestCase
  setup do
    @instrumento = instrumentos(:instrumento_1)
    @bloque = FactoryGirl.build(:bloque)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:instrumentos)
  end

  test "should create instrumento" do
    assert_difference('Instrumento.count') do
      post :create, instrumento: { descripcion: @instrumento.descripcion, nombre: @instrumento.nombre }, format: :json
    end

    assert_response 201
  end

  test "should show instrumento" do
    get :show, id: @instrumento, format: :json
    assert_response :success
  end

  test "should update instrumento" do
    patch :update, id: @instrumento, instrumento: { descripcion: @instrumento.descripcion, nombre: @instrumento.nombre }, format: :json
    assert_response 200
  end

  test "debería crear un instrumento con un bloque nuevo anidado" do
    assert_difference('Bloque.count') do
      assert_difference('Instrumento.count') do
        post :create, 
              instrumento: { 
                descripcion: @instrumento.descripcion, nombre: @instrumento.nombre, bloques_attributes: [{ 
                  nombre: @bloque.nombre, descripcion: @bloque.descripcion, tipo: @bloque.tipo 
                }]
              }, format: :json
      end
    end
    assert_response 201
  end

  test "debería crear un instrumento con un bloque existente anidado" do
    @bloque = bloques(:bloque_1)
    assert_no_difference('Bloque.count') do
      assert_difference('Instrumento.count') do
        post :create, 
              instrumento: { 
                descripcion: @instrumento.descripcion, nombre: @instrumento.nombre, bloque_ids: [ 
                  @bloque.id
                ]
              }, format: :json
        get_context(request,response)
      end
    end
    assert_response 201
  end

  test "should destroy instrumento" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Instrumento.count', -1) do
      delete :destroy, id: @instrumento, format: :json
    end

    assert_response 204
  end
end
