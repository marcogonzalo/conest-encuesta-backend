require 'jwt_authentication/auth_token'
class Usuario < ActiveRecord::Base
	belongs_to :rol

	def generate_auth_token
		payload = { user_id: self.id }
		token = AuthToken.encode(payload)
		self.token = token
		self.save
		token
	end

	def super_admin?
		return self.rol.nombre.eql?('SuperAdmin')
	end
end
