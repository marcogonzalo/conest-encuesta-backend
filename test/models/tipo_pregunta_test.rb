require 'test_helper'

class TipoPreguntaTest < ActiveSupport::TestCase
	test "no debería guardar un tipo_pregunta vacía" do
		tipo_pregunta = TipoPregunta.new
		assert_not tipo_pregunta.save, "Guardada un tipo_pregunta vacía"
	end

	test "debería guardar un tipo_pregunta sin nombre" do
		tipo_pregunta = TipoPregunta.new(valor: "12", valor_html: "")
		assert_not tipo_pregunta.save, "Guardada un tipo_pregunta sin consulta"
	end

	test "debería guardar un tipo_pregunta sin valor" do
		tipo_pregunta = TipoPregunta.new(nombre: "Nombre", valor_html: "")
		assert_not tipo_pregunta.save, "Guardada un tipo_pregunta sin valor"
	end

	test "no debería guardar un tipo_pregunta con valor_html nulo" do
		tipo_pregunta = TipoPregunta.new(nombre: "nombre", valor: "12")
		assert_not tipo_pregunta.save, "Guardó un tipo_pregunta con valor_html nulo"
	end

	test "debería guardar un tipo_pregunta válida" do
		tipo_pregunta = TipoPregunta.new(nombre: "nombre", valor: "12", valor_html: "")
		assert tipo_pregunta.save, "No guardó un tipo_pregunta válida #{tipo_pregunta.errors.inspect}"
	end
end
