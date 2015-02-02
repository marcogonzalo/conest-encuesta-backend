require 'test_helper'

class RespuestaTest < ActiveSupport::TestCase
	setup do
		@pregunta = preguntas(:pregunta_1)
		@consulta = consultas(:consulta_1)
	end

	test "no debería guardar una respuesta vacía" do
		respuesta = Respuesta.new
		assert_not respuesta.save, "Guardada una respuesta vacía"
	end

	test "no debería guardar una respuesta sin pregunta" do
		respuesta = Respuesta.new(consulta: @consulta, valor: "12")
		assert_not respuesta.save, "Guardada una respuesta sin pregunta"
	end

	test "debería guardar una respuesta sin consulta" do
		respuesta = Respuesta.new(pregunta: @pregunta, valor: "12")
		assert_not respuesta.save, "Guardada una respuesta sin consulta"
	end

	test "debería guardar una respuesta sin valor" do
		respuesta = Respuesta.new(pregunta: @pregunta, consulta: @consulta)
		assert_not respuesta.save, "Guardada una respuesta sin valor"
	end

	test "debería guardar una respuesta válida" do
		respuesta = Respuesta.new(pregunta: @pregunta, consulta: @consulta, valor: "12")
		assert respuesta.save, "No guardó una respuesta válida #{respuesta.errors.inspect}"
	end
end
