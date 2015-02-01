require 'test_helper'

class ConsultaTest < ActiveSupport::TestCase
	setup do
		@instrumento = instrumentos(:instrumento_1)
		@oferta_academica = oferta_academica(:oferta_academica_1)
	end

	test "no debería guardar una consulta vacía" do
		consulta = Consulta.new
		assert_not consulta.save, "Guardada una consulta vacia"
	end

	test "no debería guardar una consulta sin oferta académica" do
		consulta = Consulta.new(instrumento: @instrumento)
		assert_not consulta.save, "Guardada una consulta sin oferta académica"
	end

	test "no debería guardar una consulta sin instrumento" do
		consulta = Consulta.new(oferta_academica: @oferta_academica)
		assert_not consulta.save, "Guardada una consulta sin oferta académica"
	end
end
