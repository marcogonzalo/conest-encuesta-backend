class Pregunta < ActiveRecord::Base
	has_and_belongs_to_many :bloques
	has_many :preguntas
	has_many :opciones
	belongs_to :tipo_pregunta

	validates :interrogante,
				length: { maximum: 100 },
				presence: true

	validates :descripcion,
				length: { maximum: 255 },
				allow_blank: true

	validates :tipo_pregunta_id,
				numericality: { only_integer: true },
				presence: true
end
