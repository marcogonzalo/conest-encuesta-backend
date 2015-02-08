class Estudiante < ActiveRecord::Base
	has_many :control_consultas
	has_many :oferta_academica, through: :control_consultas

	validates :cedula,
				length: { in: 4..20 },
				presence: true,
				uniqueness: true

	validates :primer_nombre,
				length: { maximum: 45 },
				presence: true

	validates :segundo_nombre,
				length: { maximum: 45 }

	validates :primer_apellido,
				length: { maximum: 45 },
				presence: true

	validates :segundo_apellido,
				length: { maximum: 45 }
end
