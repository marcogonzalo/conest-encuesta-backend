class ControlConsulta < ActiveRecord::Base
	belongs_to :oferta_academica
	belongs_to :estudiante

	scope :sin_responder, -> { where(respondida: false) }

=begin
	ESTATUS = Hash["A"   => "Aprobado", 
				   "AP"  => "Aplazado",
				   "RET" => "Retirado",
				   "SC"  => "Sin Clasificar"]
=end
	validates :oferta_academica_id,
				numericality: { only_integer: true },
				presence: true

	validates :estudiante_id, 
				numericality: { only_integer: true },
				presence: true

	def self.respondida?(oa_id, e_id)
		ControlConsulta.where(estudiante_id: e_id, oferta_academica_id: oa_id).first.respondida
	end
end