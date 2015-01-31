class Token < ActiveRecord::Base
	validates :token,
				length: { maximum: 45 },
				presence: true

	validates :sha1_sum,
				length: { maximum: 255 },
				allow_blank: true
end
