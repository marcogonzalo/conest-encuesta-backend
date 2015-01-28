class OfertaAcademica < ActiveRecord::Base
  belongs_to :oferta_periodo
  belongs_to :docente
end
