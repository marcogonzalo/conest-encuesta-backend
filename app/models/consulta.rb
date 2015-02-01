class Consulta < ActiveRecord::Base
	belongs_to :oferta_academica
	belongs_to :instrumento

	validates :oferta_academica_id, 
				numericality: { only_integer: true },
				presence: true

	validates :instrumento_id, 
				numericality: { only_integer: true },
				presence: true
end
