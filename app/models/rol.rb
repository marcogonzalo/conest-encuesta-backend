class Rol < ActiveRecord::Base
	has_and_belongs_to_many :permisos
	def asignar_permisos(permisos)
		self.permisos.destroy_all
		permisos.each do |p|
			permiso = Permiso.find(p)
		    self.permisos << permiso
	    end
    end
end
