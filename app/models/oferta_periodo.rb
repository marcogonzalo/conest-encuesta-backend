class OfertaPeriodo < ActiveRecord::Base
	has_many	:oferta_academica, :dependent => :destroy
	belongs_to 	:materia
	belongs_to 	:periodo_academico
	belongs_to 	:docente_coordinador, :class_name => 'Docente', :foreign_key => 'docente_coordinador'

	validates :materia_id,
				numericality: { only_integer: true },
				presence: true

	validates :periodo_academico_id,
				numericality: { only_integer: true },
				presence: true

	validates :docente_coordinador,
				numericality: { only_integer: true },
				presence: true
end
