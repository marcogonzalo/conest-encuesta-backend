class PeriodoAcademico < ActiveRecord::Base
	has_many :ofertas_periodo

	validates :periodo,
				presence: true,
				uniqueness: true

	validates :asignaturas_hash_sum,
				presence: true,
				uniqueness: true

	validates :estudiantes_hash_sum,
				allow_nil: true,
				allow_blank: true,
				uniqueness: true
end
