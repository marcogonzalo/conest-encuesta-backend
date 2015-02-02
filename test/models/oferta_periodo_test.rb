require 'test_helper'

class OfertaPeriodoTest < ActiveSupport::TestCase
	setup do
		@materia = materias(:materia_1)
		@pa = periodos_academicos(:periodo_academico_1)
		@docente = docentes(:docente_1)
	end

	test "no debería guardar una oferta en período vacía" do
		oferta = OfertaPeriodo.new
		assert_not oferta.save, "Guardada una oferta en período vacía"
	end

	test "no debería guardar una oferta en período sin materia" do
		oferta = OfertaPeriodo.new(periodo_academico: @pa, docente_coordinador: @docente)
		assert_not oferta.save, "Guardada una oferta en período sin materia"
	end

	test "debería guardar una oferta en período sin período académico" do
		oferta = OfertaPeriodo.new(materia: @materia, docente_coordinador: @docente)
		assert_not oferta.save, "Guardada una oferta en período sin período académico"
	end

	test "debería guardar una oferta en período sin docente" do
		oferta = OfertaPeriodo.new(materia: @materia, periodo_academico: @pa)
		assert_not oferta.save, "Guardada una oferta en período sin docente"
	end

	test "debería guardar una oferta en período válida" do
		oferta = OfertaPeriodo.new(materia: @materia, periodo_academico: @pa, docente_coordinador: @docente)
		assert oferta.save, "No guardó una oferta en período válida #{oferta.errors.inspect}"
	end
end
