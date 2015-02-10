class Docente < ActiveRecord::Base
	has_many :ofertas_periodo, foreign_key: 'docente_coordinador'
	has_many :oferta_academica

	validates :cedula,
				length: { in: 3..20 },
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
