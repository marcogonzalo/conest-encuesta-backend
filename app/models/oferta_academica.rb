class OfertaAcademica < ActiveRecord::Base
	has_one :consulta, :dependent => :destroy
	has_many :control_consultas, :dependent => :destroy
	belongs_to :oferta_periodo
	belongs_to :docente

	scope :sin_responder_consulta, ->  	{ 
											where("control_consultas.respondida = ?", false) 
										}

	validates :oferta_periodo_id,
				numericality: { only_integer: true },
				presence: true

	validates :nombre_seccion,
				length: { maximum: 10 },
				presence: true

	validates :docente_id,
				numericality: { only_integer: true },
				presence: true

	validates :promedio_general,
				numericality: { in: 0..20 },
				allow_blank: true

	validates :nro_estudiantes,
				numericality: { only_integer: true },
				length: { maximum: 4 },
				allow_blank: true

	validates :nro_estudiantes_retirados,
				numericality: { only_integer: true },
				length: { maximum: 4 },
				allow_blank: true

	validates :nro_estudiantes_aprobados,
				numericality: { only_integer: true },
				length: { maximum: 4 },
				allow_blank: true

	validates :nro_estudiantes_equivalencia,
				numericality: { only_integer: true },
				length: { maximum: 4 },
				allow_blank: true

	validates :nro_estudiantes_suficiencia,
				numericality: { only_integer: true },
				length: { maximum: 4 },
				allow_blank: true

	validates :nro_estudiantes_reparacion,
				numericality: { only_integer: true },
				length: { maximum: 4 },
				allow_blank: true

	validates :nro_estudiantes_aplazados,
				numericality: { only_integer: true },
				length: { maximum: 4 },
				allow_blank: true

	validates :tipo_estatus_calificacion_id, 
				length: { maximum: 10 }, 
				allow_blank: true
end
