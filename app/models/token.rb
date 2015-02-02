class Token < ActiveRecord::Base
	validates :token,
				length: { maximum: 45 },
				presence: true

	validates :hash_sum,
				length: { maximum: 255 },
				allow_nil: false
end
