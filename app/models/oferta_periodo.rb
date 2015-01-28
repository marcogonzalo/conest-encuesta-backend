class OfertaPeriodo < ActiveRecord::Base
  belongs_to :materia
  belongs_to :periodo_academico
end
