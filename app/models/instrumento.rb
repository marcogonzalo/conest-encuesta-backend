class Instrumento < ActiveRecord::Base
	has_and_belongs_to_many :bloques
	has_many :consultas

	validates :nombre, 
				length: { maximum: 100 },
				presence: true

	validates :descripcion,
				length: { maximum: 255 }
end
