require 'test_helper'

class InstrumentoTest < ActiveSupport::TestCase
	test "no debería guardar un intrumento sin nombre" do
		intrumento = Instrumento.new
		assert_not intrumento.save, "Guardado un intrumento sin nombre"
	end

	test "debería guardar un intrumento sin descripción" do
		intrumento = Instrumento.new(nombre: "Nombre de intrumento")
		assert intrumento.save, "No se guardó un intrumento sin descripción"
	end
end
