require 'test_helper'

class BloqueTest < ActiveSupport::TestCase
	test "no debería guardar un bloque sin nombre" do
		bloque = Bloque.new
		assert_not bloque.save, "Guardado un bloque sin nombre"
	end

	test "debería guardar un bloque sin descripción" do
		bloque = Bloque.new(nombre: "Nombre de bloque", tipo: "D")
		assert bloque.save, "No se guardó un bloque sin descripción"
	end

	test "no debería guardar un bloque sin tipo" do
		bloque = Bloque.new(nombre: "Nombre de bloque")
		assert_not bloque.save, "Se guardó un bloque sin tipo"
	end

	test "no debería guardar un bloque si el tipo no coincide" do
		bloque = Bloque.new(nombre: "Nombre de bloque", tipo: "Diff")
		assert_not bloque.save, "Se guardó un bloque con un tipo no permitido"
	end

	test "no debería guardar un bloque si el tipo tiene más de 4 caracteres" do
		bloque = Bloque.new(nombre: "Nombre de bloque", tipo: "cinco")
		assert_not bloque.save, "Se guardó un bloque con un tipo de más longitud"
	end
end
