require 'test_helper'

class Api::V1::ConsultasControllerTest < ActionController::TestCase
  setup do
    @consulta = FactoryGirl.create(:consulta)
    
    @usuario = FactoryGirl.create(:usuario_superadmin)
    request.headers['Authorization'] = "Bearer " + @usuario.token.to_s 
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:consultas)
  end

  test "should create consulta" do
    assert_difference('Consulta.count') do
      post :create, consulta: { instrumento_id: @consulta.instrumento_id, oferta_academica_id: @consulta.oferta_academica_id }, format: :json
    end

    assert_response 201
  end

  test "should show consulta" do
    get :show, id: @consulta, format: :json
    assert_response :success
  end

  test "should update consulta" do
    patch :update, id: @consulta, consulta: { instrumento_id: @consulta.instrumento_id, oferta_academica_id: @consulta.oferta_academica_id }, format: :json
    assert_response 200
  end

  test "should destroy consulta" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('Consulta.count', -1) do
      delete :destroy, id: @consulta, format: :json
    end

    assert_response 204
  end

  test "debería registrar las respuestas de un estudiante asociadas a una consulta asociada" do
    @estudiante = FactoryGirl.create(:estudiante_con_consultas_por_responder)
    @respuesta1 = FactoryGirl.build(:respuesta)
    @respuesta2 = FactoryGirl.build(:respuesta)
    @respuesta3 = FactoryGirl.build(:respuesta)
    @respuesta4 = FactoryGirl.build(:respuesta)

    @consulta.oferta_academica_id = @estudiante.control_consultas.first.oferta_academica_id
    @consulta.save

    assert_difference('ControlConsulta.respondidas.count') do
      assert_difference('Respuesta.count',4) do
        post :responder, id: @consulta.id,
              consulta: { cedula_estudiante: @estudiante.cedula, 
                respuestas: [
                  { pregunta_id: @respuesta1.pregunta_id, valor: @respuesta1.valor },
                  { pregunta_id: @respuesta2.pregunta_id, valor: @respuesta2.valor },
                  { pregunta_id: @respuesta3.pregunta_id, valor: @respuesta3.valor },
                  { pregunta_id: @respuesta4.pregunta_id, valor: @respuesta4.valor }
                ] 
              }, format: :json
      end
    end

    assert_response :created
  end

  test "no debería registrar las respuestas de un estudiante si ya contestó la consulta asociada" do
    @estudiante = FactoryGirl.create(:estudiante_con_consultas_por_responder)
    @respuesta1 = FactoryGirl.build(:respuesta)
    @respuesta2 = FactoryGirl.build(:respuesta)
    @respuesta3 = FactoryGirl.build(:respuesta)
    @respuesta4 = FactoryGirl.build(:respuesta)

    @control = @estudiante.control_consultas.first
    ControlConsulta.where(oferta_academica_id: @control.oferta_academica_id, estudiante_id: @control.estudiante_id).update_all(respondida: true)
    
    @consulta.oferta_academica_id = @control.oferta_academica_id
    @consulta.save

    assert_no_difference('ControlConsulta.respondidas.count') do
      assert_no_difference('Respuesta.count') do
        post :responder, id: @consulta.id,
              consulta: { cedula_estudiante: @estudiante.cedula, 
                respuestas: [
                  { pregunta_id: @respuesta1.pregunta_id, valor: @respuesta1.valor },
                  { pregunta_id: @respuesta2.pregunta_id, valor: @respuesta2.valor },
                  { pregunta_id: @respuesta3.pregunta_id, valor: @respuesta3.valor },
                  { pregunta_id: @respuesta4.pregunta_id, valor: @respuesta4.valor }
                ] 
              }, format: :json
      end
    end

    assert_response :not_modified
  end

  test "no debería registrar las respuestas de un estudiante si no está asociado a una consulta" do
    @estudiante = FactoryGirl.create(:estudiante_con_consultas_por_responder)
    @respuesta1 = FactoryGirl.build(:respuesta)
    @respuesta2 = FactoryGirl.build(:respuesta)
    @respuesta3 = FactoryGirl.build(:respuesta)
    @respuesta4 = FactoryGirl.build(:respuesta)

    assert_no_difference('ControlConsulta.respondidas.count') do
      assert_no_difference('Respuesta.count') do
        post :responder, id: @consulta.id,
              consulta: { cedula_estudiante: @estudiante.cedula, 
                respuestas: [
                  { pregunta_id: @respuesta1.pregunta_id, valor: @respuesta1.valor },
                  { pregunta_id: @respuesta2.pregunta_id, valor: @respuesta2.valor },
                  { pregunta_id: @respuesta3.pregunta_id, valor: @respuesta3.valor },
                  { pregunta_id: @respuesta4.pregunta_id, valor: @respuesta4.valor }
                ] 
              }, format: :json
      end
    end

    assert_response :forbidden
  end

  test "no debería registrar las respuestas de un estudiante que no está registrado" do
    @estudiante = FactoryGirl.build(:estudiante_con_consultas_por_responder)
    @respuesta1 = FactoryGirl.build(:respuesta)
    @respuesta2 = FactoryGirl.build(:respuesta)
    @respuesta3 = FactoryGirl.build(:respuesta)
    @respuesta4 = FactoryGirl.build(:respuesta)

    assert_no_difference('ControlConsulta.respondidas.count') do
      assert_no_difference('Respuesta.count') do
        post :responder, id: @consulta.id,
              consulta: { cedula_estudiante: @estudiante.cedula, 
                respuestas: [
                  { pregunta_id: @respuesta1.pregunta_id, valor: @respuesta1.valor },
                  { pregunta_id: @respuesta2.pregunta_id, valor: @respuesta2.valor },
                  { pregunta_id: @respuesta3.pregunta_id, valor: @respuesta3.valor },
                  { pregunta_id: @respuesta4.pregunta_id, valor: @respuesta4.valor }
                ] 
              }, format: :json
      end
    end

    assert_response :forbidden
  end
end
