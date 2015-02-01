require 'test_helper'

class EstudianteTest < ActiveSupport::TestCase
	test "no debería guardar un estudiante vacío" do
		estudiante = Estudiante.new
		assert_not estudiante.save, "Guardado un estudiante vacío"
	end

	test "no debería guardar un estudiante sin cédula" do
		estudiante = Estudiante.new(primer_nombre: "Nombre", primer_apellido: "Apellido")
		assert_not estudiante.save, "Guardado un estudiante sin cédula"
	end 

	test "no debería guardar un estudiante sin primer nombre" do
		estudiante = Estudiante.new(cedula: 5464435, primer_apellido: "Apellido")
		assert_not estudiante.save, "Guardado un estudiante sin primer nombre"
	end 

	test "no debería guardar un estudiante sin primer apellido" do
		estudiante = Estudiante.new(cedula: 4324324, primer_nombre: "Nombre")
		assert_not estudiante.save, "Guardado un estudiante sin primer apellido"
	end
	
	test "no debería guardar un estudiante con cédula repetida" do
		estudiante1 = Estudiante.new(cedula: 4389420, primer_nombre: "Nombre", primer_apellido: "Apellido")
		assert estudiante1.valid?, "estudiante1 no es válido #{estudiante1.errors.inspect}"
		estudiante1.save

		estudiante2 = Estudiante.new(estudiante1.attributes)
		estudiante2.valid?
		assert_not_nil estudiante2.errors[:cedula], "estudiante2 no es válido #{estudiante2.errors.inspect}"
	end

	test "debería guardar un estudiante con nombre apellido y cédula" do
		estudiante = Estudiante.new(cedula: 5404376, primer_nombre: "Nombre", primer_apellido: "Apellido")
		assert estudiante.save, "No guardó un estudiante válido"
	end
end
