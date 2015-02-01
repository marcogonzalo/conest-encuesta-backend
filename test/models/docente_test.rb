require 'test_helper'

class DocenteTest < ActiveSupport::TestCase
	test "no debería guardar un docente vacío" do
		docente = Docente.new
		assert_not docente.save, "Guardado un docente vacío"
	end

	test "no debería guardar un docente sin cédula" do
		docente = Docente.new(primer_nombre: "Nombre", primer_apellido: "Apellido")
		assert_not docente.save, "Guardado un docente sin cédula"
	end 

	test "no debería guardar un docente sin primer nombre" do
		docente = Docente.new(cedula: 5464435, primer_apellido: "Apellido")
		assert_not docente.save, "Guardado un docente sin primer nombre"
	end 

	test "no debería guardar un docente sin primer apellido" do
		docente = Docente.new(cedula: 4324324, primer_nombre: "Nombre")
		assert_not docente.save, "Guardado un docente sin primer apellido"
	end
	
	test "no debería guardar un docente con cédula repetida" do
		docente1 = Docente.new(cedula: 545342, primer_nombre: "Nombre", primer_apellido: "Apellido")
		assert docente1.valid?, "docente1 no es válido #{docente1.errors.inspect}"
		docente1.save

		docente2 = Docente.new(docente1.attributes)
		docente2.valid?
		assert_not_nil docente2.errors[:cedula], "docente2 no es válido #{docente2.errors.inspect}"
	end

	test "debería guardar un docente con nombre apellido y cédula" do
		docente = Docente.new(cedula: 5404376, primer_nombre: "Nombre", primer_apellido: "Apellido")
		assert docente.save, "No guardó un docente válido"
	end
end
