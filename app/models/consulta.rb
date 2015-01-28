class Consulta < ActiveRecord::Base
  belongs_to :oferta_academica
  belongs_to :instrumento
end
