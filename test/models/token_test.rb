require 'test_helper'

class TokenTest < ActiveSupport::TestCase
	test "no debería guardar un token vacio" do
		token = Token.new
		assert_not token.save, "Guardada un token vacío"
	end

	test "debería guardar un token sin token" do
		token = Token.new(hash_sum: "")
		assert_not token.save, "Guardada un token sin token"
	end

	test "no debería guardar un token con hash_sum nulo" do
		token = Token.new(token: "AB342234BD")
		assert_not token.save, "Guardó un token con hash_sum nulo"
	end

	test "debería guardar un token válida" do
		token = Token.new(token: "AB342234BD", hash_sum: "hdsad823h32132")
		assert token.save, "No guardó un token válida #{token.errors.inspect}"
	end
end
