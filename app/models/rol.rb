class Rol < ActiveRecord::Base
	has_and_belongs_to_many :permisos
	def asignar_permisos(permisos)
		permisos.each do |p|
		#find the main permiso assigned from the UI
			permiso = Permiso.find(p.id)
		    self.permisos << permiso
=begin
			case permiso.clase
				when "Part"
					case permiso.accion
						#if create part permiso is assigned then assign create drawing as well
						when "create"
							self.permisos << Permiso.where(clase: "Drawing", accion: "create")
						#if update part permiso is assigned then assign create and delete drawing as well
						when "update"
							self.permisos << Permiso.where(clase: "Drawing", accion: ["update", "destroy"])
					end
				end
			end
=end
	    end
    end
end
