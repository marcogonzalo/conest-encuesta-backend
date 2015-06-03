class Usuario < ActiveRecord::Base
	belongs_to :rol

	def generate_auth_token
		payload = { user_id: self.id }
		AuthToken.encode(payload)
	end
end
