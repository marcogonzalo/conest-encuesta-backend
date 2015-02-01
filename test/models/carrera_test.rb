require 'test_helper'

class CarreraTest < ActiveSupport::TestCase
	test "no debería guardar una carrera vacía" do
		carrera = Carrera.new
		assert_not carrera.save, "Guardada una carrera vacia"
	end

	test "no debería guardar una carrera sin código" do
		carrera = Carrera.new(nombre: 'MyString', organizacion_id: 1234)
		assert_not carrera.save, "Guardada una carrera sin código"
	end

	test "no debería guardar una carrera sin nombre" do
		carrera = Carrera.new(codigo: 'carrera', organizacion_id: 1234)
		assert_not carrera.save, "Guardada una carrera sin nombre"
	end

	test "no debería guardar una carrera sin organización" do
		carrera = Carrera.new(codigo: 'carrera', nombre: 'MyString')
		assert_not carrera.save, "Guardada una carrera sin organización"
	end

	test "debería guardar una carrera válida" do
		carrera = Carrera.new(codigo: 'carrera', nombre: 'MyString', organizacion_id: 1234)
		assert carrera.save, "Guardada una carrera no válida"
	end
end
