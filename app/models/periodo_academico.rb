class PeriodoAcademico < ActiveRecord::Base
	has_many :ofertas_periodo

	validates :periodo,
				presence: true,
				uniqueness: true

	validates :hash_sum,
				presence: true,
				uniqueness: true
end
