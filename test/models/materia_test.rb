require 'test_helper'

class MateriaTest < ActiveSupport::TestCase
	setup do
		@carrera = carreras(:carrera_1)
	end

	test "no debería guardar una materia vacía" do
		materia = Materia.new
		assert_not materia.save, "Guardada una materia vacía"
	end

	test "no debería guardar una materia sin código" do
		materia = Materia.new(carrera: @carrera, plan_nombre: "Nombre de Plan", nombre: "Materia", tipo_materia_id: "O", grupo_nota_id: "aprobado")
		assert_not materia.save, "Guardada una materia sin código"
	end

	test "no debería guardar una materia sin carrera" do
		materia = Materia.new(codigo: 4389420, plan_nombre: "Nombre de Plan", nombre: "Materia", tipo_materia_id: "O", grupo_nota_id: "aprobado")
		assert_not materia.save, "Guardada una materia sin carrera"
	end

	test "no debería guardar una materia sin plan" do
		materia = Materia.new(codigo: 4389420, carrera: @carrera, nombre: "Materia", tipo_materia_id: "O", grupo_nota_id: "aprobado")
		assert_not materia.save, "Guardada una materia sin plan"
	end

	test "no debería guardar una materia sin nombre" do
		materia = Materia.new(codigo: 4389420, carrera: @carrera, plan_nombre: "Nombre de Plan", tipo_materia_id: "O", grupo_nota_id: "aprobado")
		assert_not materia.save, "Guardada una materia sin nombre"
	end

	test "no debería guardar una materia sin tipo de materia" do
		materia = Materia.new(codigo: 4389420, carrera: @carrera, plan_nombre: "Nombre de Plan", nombre: "Materia", grupo_nota_id: "aprobado")
		assert_not materia.save, "Guardada una materia sin tipo de materia"
	end

	test "no debería guardar una materia sin grupo de nota" do
		materia = Materia.new(codigo: 4389420, carrera: @carrera, plan_nombre: "Nombre de Plan", nombre: "Materia", tipo_materia_id: "O")
		assert_not materia.save, "Guardada una materia sin grupo de nota"
	end

	test "no debería guardar con un tipo de materia no válido" do
		materia = Materia.new(codigo: 4389420, carrera: @carrera, plan_nombre: "Nombre de Plan", nombre: "Materia", tipo_materia_id: "H", grupo_nota_id: "aprobado")
		assert_not materia.save, "Guardada una materia con tipo de materia no válido"
	end

	test "no debería guardar una materia con ccódigo repetido" do
		materia1 = Materia.new(codigo: 4389420, carrera: @carrera, plan_nombre: "Nombre de Plan", nombre: "Materia", tipo_materia_id: "O", grupo_nota_id: "aprobado")
		assert materia1.valid?, "materia1 no es válida #{materia1.errors.inspect}"
		materia1.save

		materia2 = Materia.new(materia1.attributes)
		materia2.valid?
		assert_not_nil materia2.errors[:codigo], "materia2 no es válida #{materia2.errors.inspect}"
	end
end
