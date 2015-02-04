require 'test_helper'

class Api::V1::OfertaAcademicaControllerTest < ActionController::TestCase
  setup do
    @oferta_academica = FactoryGirl.create(:oferta_academica)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:oferta_academica)
  end

  test "should create oferta_academica" do
    oferta_academica = FactoryGirl.build(:oferta_academica)
    assert_difference('OfertaAcademica.count') do
      post :create, oferta_academica: { docente_id: oferta_academica.docente_id, nombre_seccion: oferta_academica.nombre_seccion, nro_estudiantes: oferta_academica.nro_estudiantes, nro_estudiantes_aplazados: oferta_academica.nro_estudiantes_aplazados, nro_estudiantes_aprobados: oferta_academica.nro_estudiantes_aprobados, nro_estudiantes_equivalencia: oferta_academica.nro_estudiantes_equivalencia, nro_estudiantes_reparacion: oferta_academica.nro_estudiantes_reparacion, nro_estudiantes_retirados: oferta_academica.nro_estudiantes_retirados, nro_estudiantes_suficiencia: oferta_academica.nro_estudiantes_suficiencia, oferta_periodo_id: oferta_academica.oferta_periodo_id, promedio_general: oferta_academica.promedio_general, tipo_estatus_calificacion_id: oferta_academica.tipo_estatus_calificacion_id }, format: :json
    end

    assert_response 201
  end

  test "should show oferta_academica" do
    get :show, id: @oferta_academica, format: :json
    assert_response :success
  end

  test "should update oferta_academica" do
    patch :update, id: @oferta_academica, oferta_academica: { docente_id: @oferta_academica.docente_id, nombre_seccion: @oferta_academica.nombre_seccion, nro_estudiantes: @oferta_academica.nro_estudiantes, nro_estudiantes_aplazados: @oferta_academica.nro_estudiantes_aplazados, nro_estudiantes_aprobados: @oferta_academica.nro_estudiantes_aprobados, nro_estudiantes_equivalencia: @oferta_academica.nro_estudiantes_equivalencia, nro_estudiantes_reparacion: @oferta_academica.nro_estudiantes_reparacion, nro_estudiantes_retirados: @oferta_academica.nro_estudiantes_retirados, nro_estudiantes_suficiencia: @oferta_academica.nro_estudiantes_suficiencia, oferta_periodo_id: @oferta_academica.oferta_periodo_id, promedio_general: @oferta_academica.promedio_general, tipo_estatus_calificacion_id: @oferta_academica.tipo_estatus_calificacion_id }, format: :json
    assert_response 200
  end

  test "should destroy oferta_academica" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('OfertaAcademica.count', -1) do
      delete :destroy, id: @oferta_academica, format: :json
    end

    assert_response 204
  end
end
