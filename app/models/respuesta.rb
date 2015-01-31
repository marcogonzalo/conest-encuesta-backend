class Respuesta < ActiveRecord::Base
	belongs_to :consulta
	belongs_to :pregunta

	validates :consulta_id,
				numericality: { only_integer: true },
				presence: true

	validates :pregunta_id,
				numericality: { only_integer: true },
				presence: true

	validates :valor_respuesta,
				length: { maximum: 45 },
				presence: true
end
