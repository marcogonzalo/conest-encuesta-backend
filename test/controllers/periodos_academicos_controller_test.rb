require 'test_helper'

class Api::V1::PeriodosAcademicosControllerTest < ActionController::TestCase
  setup do
    @periodo_academico = FactoryGirl.create(:periodo_academico)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:periodos_academicos)
  end

  test "should create periodo_academico" do
    FactoryGirl.create(:token)
    periodo_academico = FactoryGirl.build(:periodo_academico)

    assert_difference('Consulta.count',5) do
      assert_difference('OfertaAcademica.count',5) do
        assert_difference('OfertaPeriodo.count',4) do
          assert_difference('Docente.count',5) do
            assert_difference('Materia.count',4) do
              assert_difference('Carrera.count') do
                assert_difference('PeriodoAcademico.count') do
                  post :create, periodo_academico: { asignaturas_hash_sum: periodo_academico.asignaturas_hash_sum, periodo: "01-2014", sincronizacion: periodo_academico.sincronizacion }, format: :json
                end
              end
            end
          end
        end
      end
    end

    assert_response 201
  end

  test "deberia devolverme estatus :not_modified si el asignaturas_hash_sum de un periodo existente es identico al sha1_sum enviado desde Conest" do
    FactoryGirl.create(:token)
    periodo_academico = FactoryGirl.build(:periodo_academico)

    assert_difference('PeriodoAcademico.count') do
      post :create, periodo_academico: { periodo: "01-2014" }, format: :json
      assert_response 201
    end

    # Envio nuevamente el mismo periodo
    assert_no_difference('PeriodoAcademico.count') do
      post :create, periodo_academico: { periodo: "01-2014" }, format: :json
      assert_response 304
    end

  end

  test "should show periodo_academico" do
    get :show, id: @periodo_academico, format: :json
    assert_response :success
  end

  test "should update periodo_academico" do
    patch :update, id: @periodo_academico, periodo_academico: { asignaturas_hash_sum: @periodo_academico.asignaturas_hash_sum, periodo: @periodo_academico.periodo, sincronizacion: @periodo_academico.sincronizacion }, format: :json
    assert_response 200
  end

  test "should destroy periodo_academico" do
    skip "No puede borrarse por dependencias creadas"
    assert_difference('PeriodoAcademico.count', -1) do
      delete :destroy, id: @periodo_academico, format: :json
    end

    assert_response 204
  end

  test "deberia crear el control de consultas para cada estudiante en un periodo_academico" do
    
    FactoryGirl.create(:token)
    periodo_academico = FactoryGirl.build(:periodo_academico)

    assert_difference('PeriodoAcademico.count') do
      post :create, periodo_academico: { asignaturas_hash_sum: periodo_academico.asignaturas_hash_sum, periodo: "01-2014", sincronizacion: periodo_academico.sincronizacion }, format: :json
      assert_response 201
    end

    assert_difference('ControlConsulta.count',7) do
      post :sincronizar_estudiantes, periodo: "01-2014", format: :json
    end

    assert_response 200
  end
end
