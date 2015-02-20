class Consulta < ActiveRecord::Base
	has_many :respuestas
	belongs_to :oferta_academica
	belongs_to :instrumento

	validates :oferta_academica_id, 
				numericality: { only_integer: true },
				presence: true

	validates :instrumento_id, 
				numericality: { only_integer: true },
				presence: true
end
