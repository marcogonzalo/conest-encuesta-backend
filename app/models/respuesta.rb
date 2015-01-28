class Respuesta < ActiveRecord::Base
  belongs_to :consulta
  belongs_to :pregunta
end
