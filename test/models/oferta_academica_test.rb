require 'test_helper'

class OfertaAcademicaTest < ActiveSupport::TestCase
	setup do
		@op = ofertas_periodo(:oferta_periodo_1)
		@docente = docentes(:docente_1)
	end

	test "no debería guardar una oferta académica vacía" do
		oferta = OfertaAcademica.new
		assert_not oferta.save, "Guardada una oferta académica vacía"
	end

	test "no debería guardar una oferta académica sin oferta en período" do
		oferta = OfertaAcademica.new(nombre_seccion: "B1", docente: @docente)
		assert_not oferta.save, "Guardada una oferta académica sin oferta en período"
	end

	test "debería guardar una oferta académica sin nombre de sección" do
		oferta = OfertaAcademica.new(oferta_periodo: @op, docente: @docente)
		assert_not oferta.save, "Guardada una oferta académica sin nombre de sección"
	end

	test "debería guardar una oferta académica sin docente" do
		oferta = OfertaAcademica.new(oferta_periodo: @op, nombre_seccion: "B1")
		assert_not oferta.save, "Guardada una oferta académica sin docente"
	end

	test "debería guardar una oferta académica válida" do
		oferta = OfertaAcademica.new(oferta_periodo: @op, nombre_seccion: "B1", docente: @docente)
		assert oferta.save, "Guardada una oferta académica no válida"
	end
end
