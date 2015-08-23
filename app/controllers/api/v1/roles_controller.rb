module Api
	module V1
		class RolesController < ApplicationController
			load_and_authorize_resource
			before_action :es_super_admin?, except: [:show, :puede]
			before_action :set_rol, only: [:show, :edit, :update, :destroy, :puede]

			def index
				#Listar permisos que no son de SuperAdmin.
				@roles = Rol.all.select{|i| i.nombre != "SuperAdmin"}
				render json: @roles
			end

			def show
				@permisos = @rol.permisos
				render json: {rol: @rol, permisos: @permisos }
			end

			def edit
		#		@permisos = Permiso.all.select{|i| ["Part"].include? i.subject_class}.compact
				@permisos = Permiso.all
				@rol_permisos = @rol.permisos.collect{|p| p.id}
				render json: {rol: @rol, permisos: @permisos, permisos_rol: @rol_permisos }
			end

			def update
				@rol.permisos = []
				@rol.asignar_permisos(params[:permisos]) if params[:permisos]
				@rol.save

		#		@permisos = Permiso.all.select{|i| ["Part"].include? i.subject_class}.compact
				@permisos = Permiso.all
				render json: {rol: @rol, permisos: @permisos, permisos_rol: @rol.permisos }
			end

			private
			def set_rol
				@rol = Rol.find(params[:id])
			end
		end
	end
end