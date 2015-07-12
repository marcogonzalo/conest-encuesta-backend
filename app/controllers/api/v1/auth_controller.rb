module Api
	module V1
		class AuthController < ApplicationController
			skip_before_action :authenticate_request
			before_action :set_usuario
		  def authenticate
		  	if @usuario
		      render json: {cedula: @usuario.cedula, rol: {nombre: 'admin'}, auth_token: @usuario.generate_auth_token }
		    else
		      render json: { error: 'Nombre de usuario o clave inválido' }, status: :unauthorized
		    end
		  end

		  private
		  def set_usuario
		  	@usuario = Usuario.find_by(cedula: params[:cedula], clave: params[:clave]) # you'll need to implement this
		  end
		end
	end
end
