class Instrumento < ActiveRecord::Base
	has_and_belongs_to_many :bloques
	has_many :preguntas, through: :bloques 
	has_many :consultas
	accepts_nested_attributes_for :bloques

	validates :nombre, 
				length: { maximum: 100 },
				presence: true

	validates :descripcion,
				length: { maximum: 255 }
end
