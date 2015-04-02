class Opcion < ActiveRecord::Base
	belongs_to :pregunta

	validates :etiqueta,
				length: { maximum: 100 },
				presence: true

	validates :valor,
				numericality: true,
				presence: true

	validates :pregunta_id,
				numericality: { only_integer: true },
				allow_nil: true
end
