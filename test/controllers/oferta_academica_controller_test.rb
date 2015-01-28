require 'test_helper'

class OfertaAcademicaControllerTest < ActionController::TestCase
  setup do
    @oferta_academica = oferta_academica(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oferta_academica)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create oferta_academica" do
    assert_difference('OfertaAcademica.count') do
      post :create, oferta_academica: { docente_id: @oferta_academica.docente_id, nombre_seccion: @oferta_academica.nombre_seccion, nro_estudiantes: @oferta_academica.nro_estudiantes, nro_estudiantes_aplazados: @oferta_academica.nro_estudiantes_aplazados, nro_estudiantes_aprobados: @oferta_academica.nro_estudiantes_aprobados, nro_estudiantes_equivalencia: @oferta_academica.nro_estudiantes_equivalencia, nro_estudiantes_reparacion: @oferta_academica.nro_estudiantes_reparacion, nro_estudiantes_retirados: @oferta_academica.nro_estudiantes_retirados, nro_estudiantes_suficiencia: @oferta_academica.nro_estudiantes_suficiencia, oferta_periodo_id: @oferta_academica.oferta_periodo_id, promedio_general: @oferta_academica.promedio_general, tipo_estatus_calificacion_id: @oferta_academica.tipo_estatus_calificacion_id }
    end

    assert_redirected_to oferta_academica_path(assigns(:oferta_academica))
  end

  test "should show oferta_academica" do
    get :show, id: @oferta_academica
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @oferta_academica
    assert_response :success
  end

  test "should update oferta_academica" do
    patch :update, id: @oferta_academica, oferta_academica: { docente_id: @oferta_academica.docente_id, nombre_seccion: @oferta_academica.nombre_seccion, nro_estudiantes: @oferta_academica.nro_estudiantes, nro_estudiantes_aplazados: @oferta_academica.nro_estudiantes_aplazados, nro_estudiantes_aprobados: @oferta_academica.nro_estudiantes_aprobados, nro_estudiantes_equivalencia: @oferta_academica.nro_estudiantes_equivalencia, nro_estudiantes_reparacion: @oferta_academica.nro_estudiantes_reparacion, nro_estudiantes_retirados: @oferta_academica.nro_estudiantes_retirados, nro_estudiantes_suficiencia: @oferta_academica.nro_estudiantes_suficiencia, oferta_periodo_id: @oferta_academica.oferta_periodo_id, promedio_general: @oferta_academica.promedio_general, tipo_estatus_calificacion_id: @oferta_academica.tipo_estatus_calificacion_id }
    assert_redirected_to oferta_academica_path(assigns(:oferta_academica))
  end

  test "should destroy oferta_academica" do
    assert_difference('OfertaAcademica.count', -1) do
      delete :destroy, id: @oferta_academica
    end

    assert_redirected_to oferta_academica_index_path
  end
end
