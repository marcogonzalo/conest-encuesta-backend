class Bloque < ActiveRecord::Base
	has_and_belongs_to_many :instrumentos
	has_and_belongs_to_many :preguntas
	accepts_nested_attributes_for :preguntas

	TIPO = Hash["D"  => "Docente", 
				"L"  => "Laboratorio",
				"P"  => "Práctica",
				"T"  => "Teoría"]

	validates :nombre, 
				length: { maximum: 100 },
				presence: true

	validates :descripcion,
				length: { maximum: 255 }

	validates :tipo,
				length: { in: 1..4 },
				inclusion: { in: TIPO.keys },
				presence: true
end
