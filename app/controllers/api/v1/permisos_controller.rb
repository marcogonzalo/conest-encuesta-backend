module Api
	module V1
		class PermisosController < ApplicationController
#			load_and_authorize_resource
			before_action :cargar_permisos # call this after load_and_authorize else it gives a cancan error

	 		def puede
				puede = @current_user.super_admin? ? true : @permisos_de_usuario.include?(params[:nombre_permiso])
				render json: { puede: puede }
			end
		end
	end
end
