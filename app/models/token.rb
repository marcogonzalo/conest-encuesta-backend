class Token < ActiveRecord::Base
	validates :token,
				length: { maximum: 45 },
				presence: true

	validates :hash_sum,
				length: { maximum: 255 },
				allow_nil: false

	def self.actual
		t = Token.last
		t.nil? ? nil : t.token
	end
end
