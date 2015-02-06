require 'test_helper'

class Api::V1::InstrumentosControllerTest < ActionController::TestCase
  setup do
    @instrumento = instrumentos(:instrumento_1)
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
    @bloque = FactoryGirl.build(:bloque)
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

  test "debería crear un instrumento con un bloque nuevo y preguntas nuevas anidados" do
    @bloque = FactoryGirl.build(:bloque)
    @pregunta1 = FactoryGirl.build(:pregunta)
    @pregunta2 = FactoryGirl.build(:pregunta)
    assert_difference('Pregunta.count',2) do
      assert_difference('Bloque.count') do
        assert_difference('Instrumento.count') do
          post :create, 
                instrumento: { 
                  descripcion: @instrumento.descripcion, nombre: @instrumento.nombre, 
                  bloques_attributes: [{ 
                    nombre: @bloque.nombre, descripcion: @bloque.descripcion, tipo: @bloque.tipo,
                    preguntas_attributes: [
                      { interrogante: @pregunta1.interrogante, descripcion: @pregunta1.descripcion, tipo_pregunta_id: @pregunta1.tipo_pregunta_id },
                      { interrogante: @pregunta2.interrogante, descripcion: @pregunta2.descripcion, tipo_pregunta_id: @pregunta2.tipo_pregunta_id }
                    ]
                  }]
                }, format: :json
        end
      end
    end
    assert_response 201
  end

  test "debería crear un instrumento con un bloque nuevo y preguntas nuevas con sus opciones anidados" do
    @bloque = FactoryGirl.build(:bloque)
    @pregunta1 = FactoryGirl.build(:pregunta)
    @pregunta2 = FactoryGirl.build(:pregunta)
    @opcion1 = FactoryGirl.build(:opcion)
    @opcion2 = FactoryGirl.build(:opcion)
    @opcion3 = FactoryGirl.build(:opcion)
    @opcion4 = FactoryGirl.build(:opcion)
    @opcion5 = FactoryGirl.build(:opcion)
    @opcion6 = FactoryGirl.build(:opcion)
    assert_difference('Opcion.count',6) do
      assert_difference('Pregunta.count',2) do
        assert_difference('Bloque.count') do
          assert_difference('Instrumento.count') do
            post :create, 
                  instrumento: { 
                    descripcion: @instrumento.descripcion, nombre: @instrumento.nombre, 
                    bloques_attributes: [{ 
                      nombre: @bloque.nombre, descripcion: @bloque.descripcion, tipo: @bloque.tipo,
                      preguntas_attributes: [
                        { interrogante: @pregunta1.interrogante, descripcion: @pregunta1.descripcion, tipo_pregunta_id: @pregunta1.tipo_pregunta_id, 
                          opciones_attributes: [
                            { etiqueta: @opcion1.etiqueta, valor: @opcion1.valor },
                            { etiqueta: @opcion2.etiqueta, valor: @opcion2.valor }
                          ] 
                        },
                        { interrogante: @pregunta2.interrogante, descripcion: @pregunta2.descripcion, tipo_pregunta_id: @pregunta2.tipo_pregunta_id, 
                          opciones_attributes: [
                            { etiqueta: @opcion3.etiqueta, valor: @opcion3.valor },
                            { etiqueta: @opcion4.etiqueta, valor: @opcion4.valor },
                            { etiqueta: @opcion5.etiqueta, valor: @opcion5.valor },
                            { etiqueta: @opcion6.etiqueta, valor: @opcion6.valor }
                          ] 
                        }
                      ]
                    }]
                  }, format: :json
            get_context(request,response)
          end
        end
      end
    end
    assert_response 201
  end

  test "debería crear un instrumento con un bloque existente anidado" do
    skip
    @bloque = bloques(:bloque_1)
    assert_no_difference('Bloque.count') do
      assert_difference('Instrumento.count') do
        post :create, 
              instrumento: { 
                descripcion: @instrumento.descripcion, nombre: @instrumento.nombre, bloque_ids: [ 
                  @bloque.id
                ]
              }, format: :json
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
