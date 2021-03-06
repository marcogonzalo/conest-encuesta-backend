require 'test_helper'

class Api::V1::OfertasPeriodoControllerTest < ActionController::TestCase
  setup do
    @oferta_periodo = FactoryGirl.create(:oferta_periodo)
    @consulta = FactoryGirl.create(:consulta)
    @periodo_academico = FactoryGirl.create(:periodo_academico)

    @usuario = FactoryGirl.create(:usuario_superadmin)
    request.headers['Authorization'] = "Bearer " + @usuario.token.to_s 
  end

  test "should get index" do
    get :index, periodo_academico_id: @consulta.oferta_academica.oferta_periodo.periodo_academico_id, format: :json
    assert_response :success
    assert_not_nil assigns(:ofertas_periodo)
  end

  test "should create oferta_periodo" do
    skip "create oferta_periodo"
    oferta_periodo = FactoryGirl.build(:oferta_periodo)
    @docente = FactoryGirl.create(:docente)
    assert_difference('OfertaPeriodo.count') do
      post :create, periodo_academico_id: @periodo_academico.id, oferta_periodo: { docente_coordinador: @docente.id, materia_id: oferta_periodo.materia_id, periodo_academico_id: @periodo_academico.id }, format: :json
    end

    assert_response 201
  end

  test "should show oferta_periodo" do
    get :show, periodo_academico_id: @oferta_periodo.periodo_academico_id, id: @oferta_periodo, format: :json
    assert_response :success
  end

  test "should update oferta_periodo" do
    patch :update, periodo_academico_id: @oferta_periodo.periodo_academico, id: @oferta_periodo, oferta_periodo: { docente_coordinador: @oferta_periodo.docente_coordinador, materia_id: @oferta_periodo.materia_id, periodo_academico_id: @oferta_periodo.periodo_academico_id }, format: :json
    assert_response 200
  end

  test "debe cambiar el instrumento de de las consultas de una materia en un periodo si no existen respuestas a la consulta" do
    @instrumento = FactoryGirl.create(:instrumento)
    @oferta_periodo.oferta_academica.each do |seccion|
      seccion.consulta.respuestas.destroy_all
    end

    patch :cambiar_instrumento, id: @oferta_periodo.id, instrumento_id: @instrumento.id, format: :json
    assert_response 200
  end

  test "no debe cambiar el instrumento de de las consultas de una materia en un periodo si existen respuestas a la consulta" do
    @instrumento = FactoryGirl.create(:instrumento)
    @respuesta = FactoryGirl.create(:respuesta)

    patch :update, periodo_academico_id: @oferta_periodo.periodo_academico, id: @oferta_periodo, oferta_periodo: { docente_coordinador: @oferta_periodo.docente_coordinador, materia_id: @oferta_periodo.materia_id, periodo_academico_id: @oferta_periodo.periodo_academico_id }, format: :json
    assert_response 200
  end

  test "should destroy oferta_periodo" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('OfertaPeriodo.count', -1) do
      delete :destroy, id: @oferta_periodo, format: :json
    end

    assert_response 204
  end
end
