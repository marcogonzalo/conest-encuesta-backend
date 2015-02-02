require 'test_helper'

class PreguntaTest < ActiveSupport::TestCase
	setup do
		@tp = tipos_pregunta(:tipo_pregunta_1)
	end

	test "no debería guardar una pregunta vacía" do
		pregunta = Pregunta.new
		assert_not pregunta.save, "Guardada una pregunta vacía"
	end

	test "no debería guardar una pregunta sin tipo de pregunta" do
		pregunta = Pregunta.new(interrogante: "interrogante")
		assert_not pregunta.save, "Guardada una pregunta sin tipo de pregunta"
	end

	test "debería guardar una pregunta sin interrogante" do
		pregunta = Pregunta.new(tipo_pregunta: @tp)
		assert_not pregunta.save, "Guardada una pregunta sin interrogante"
	end

	test "debería guardar una pregunta sin descripción" do
		pregunta = Pregunta.new(tipo_pregunta: @tp, interrogante: "interrogante")
		assert pregunta.save, "Guardada una pregunta sin descripción"
	end

	test "debería guardar una pregunta válida" do
		pregunta = Pregunta.new(tipo_pregunta: @tp, interrogante: "interrogante", descripcion: "descripción")
		assert pregunta.save, "No guardó una pregunta válida #{pregunta.errors.inspect}"
	end
end
