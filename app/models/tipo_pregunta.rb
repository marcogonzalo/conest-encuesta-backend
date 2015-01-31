class TipoPregunta < ActiveRecord::Base
	has_many :preguntas

	validates :nombre,
				length: { maximum: 45 },
				presence: true

	validates :valor,
				length: { maximum: 45 },
				presence: true

	validates :valor_html,
				length: { maximum: 45 },
				allow_blank: true
end
