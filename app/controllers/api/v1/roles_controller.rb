module Api
	module V1
		class RolesController < ApplicationController
			load_and_authorize_resource
			before_action :cargar_permisos # call this after load_and_authorize else it gives a cancan error
			before_action :es_super_admin?, except: [:show]
			before_action :set_rol, only: [:show, :edit, :update, :destroy]

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
		 
			def es_super_admin?
				redirect_to home_path and return unless @current_user.super_admin?
			end
		end
	end
end