module Api
	module V1
		class UsuariosController < ApplicationController
			authorize_resource
			before_action :es_super_admin?
			before_action :set_usuario, only: [:show, :edit, :update]
			before_action :set_rol, only: [:update]

			def index
				@usuarios = Usuario.includes(:rol).all.order(updated_at: :desc).limit(10).select{|i| i.rol_id != 1}
				render json: @usuarios, :include => :rol
			end

			def show
				puts params[:id]
				render json: {usuario: @usuario, rol: @usuario.rol }
			end

			def edit
				@roles = Rol.all.select{|i| i.nombre != 'SuperAdmin'}
				render json: {usuario: @usuario, roles: @roles }
			end

			def update
				unless @current_user.cedula == @usuario.cedula
					@usuario.update_attribute(:rol_id, @rol.id)
				end
				render json: {usuario: @usuario, rol: @usuario.rol }
			end

			private
			def set_usuario
				@usuario = Usuario.find_by(cedula: params['id'])
			end

			def set_rol
				@rol = Rol.find(params[:rol_id])
			end		 
		end
	end
end
