class Carrera < ActiveRecord::Base
	has_many :materias

	validates :codigo, 
				length: { maximum: 10 },
				presence: true

	validates :nombre,
				length: { maximum: 255 },
				presence: true

	validates :organizacion_id,
				length: { maximum: 10 },
				presence: true
end
