class Materia < ActiveRecord::Base
	has_many :ofertas_periodo
	belongs_to :carrera

	TIPO = Hash["C"  => "Complementaria", 
				"E"  => "Electiva",
				"L"  => "Laboratorio",
				"O"  => "Obligatoria", 
				"P"  => "Pasantía",
				"SC" => "Servicio Comunitario", 
				"S"  => "Seminario",
				"T"  => "Tesis", 
				"M"	 => "Métodos"]

	validates :codigo, 
				length: { maximum: 10 },
				presence: true, 
				uniqueness: true

	validates :carrera_id,
				numericality: { only_integer: true }

	validates :plan_nombre,
				length: { maximum: 20 },
				presence: true

	validates :nombre,
				length: { maximum: 255 },
				presence: true

	validates :tipo_materia_id,
				length: { maximum: 10 },
				inclusion: { in: TIPO.keys},
				presence: true

	validates :grupo_nota_id,
				length: { maximum: 10 },
				presence: true
end
