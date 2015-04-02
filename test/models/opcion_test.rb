require 'test_helper'

class OpcionTest < ActiveSupport::TestCase
	setup do
		@pregunta = preguntas(:pregunta_1)
	end

	test "no debería guardar una opción vacía" do
		opcion = Opcion.new
		assert_not opcion.save, "Guardada una opción vacía"
	end

	test "no debería guardar una opción sin pregunta" do
		skip
		opcion = Opcion.new(etiqueta: "Etiqueta", valor: "Valor")
		assert_not opcion.save, "Guardada una opción sin pregunta"
	end

	test "debería guardar una opción sin etiqueta" do
		opcion = Opcion.new(pregunta: @pregunta, valor: "Valor")
		assert_not opcion.save, "Guardada una opción sin etiqueta"
	end

	test "debería guardar una opción sin valor" do
		opcion = Opcion.new(pregunta: @pregunta, etiqueta: "Etiqueta")
		assert_not opcion.save, "Guardada una opción sin valor"
	end

	test "debería guardar una opción válida" do
		opcion = Opcion.new(pregunta: @pregunta, etiqueta: "Etiqueta", valor: 213)
		assert opcion.save, "No guardó una opción válida #{opcion.errors.inspect}"
	end
end
