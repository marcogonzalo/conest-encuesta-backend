require 'test_helper'

class ControlConsultaTest < ActiveSupport::TestCase
	setup do
		FactoryGirl.create(:control_consulta)
		@estudiante = FactoryGirl.create(:estudiante)
		@oferta_academica = FactoryGirl.create(:oferta_academica)
	end

	test "no debería guardar un control de consulta vacío" do
		consulta = ControlConsulta.new
		assert_not consulta.save, "Guardada un control de consulta vacio"
	end

	test "no debería guardar un contol de consulta sin oferta académica" do
		consulta = ControlConsulta.new(estudiante: @estudiante)
		assert_not consulta.save, "Guardada un control de consulta sin oferta académica"
	end

	test "no debería guardar un control de consulta sin estudiante" do
		consulta = ControlConsulta.new(oferta_academica: @oferta_academica)
		assert_not consulta.save, "Guardada un control de consulta sin estudiante"
	end

	test "debería guardar un control de consulta válido" do
		consulta = ControlConsulta.new(oferta_academica: @oferta_academica, estudiante: @estudiante)
		assert consulta.save, "No guardó un control de consulta válido"
	end

	test "debería indicar si una consulta fue respondida" do
		consulta = ControlConsulta.new(oferta_academica: @oferta_academica, estudiante: @estudiante, respondida: true)
		assert consulta.save, "No guardó un control de consulta válido"
		assert ControlConsulta::respondida?(@oferta_academica.id, @estudiante.id)
	end
end
