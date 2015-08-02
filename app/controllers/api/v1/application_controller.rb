require 'exceptions'
require 'jwt_authentication/auth_token'
module Api
	module V1
		class ApplicationController < ActionController::Base
		  # Prevent CSRF attacks by raising an exception.
		  # For APIs, you may want to use :null_session instead.
			# protect_from_forgery with: :null_session

			before_action :set_current_user, :authenticate_request

			rescue_from CanCan::AccessDenied do |exception|
				render json: { error: 'No autorizado, no tiene permisos' }, status: :unauthorized
			end

			rescue_from Exceptions::NotAuthenticatedError do
				render json: { error: 'No autorizado' }, status: :unauthorized
			end
		
			rescue_from Exceptions::AuthenticationTimeoutError do
				render json: { error: 'Tiempo de autenticación vencido' }, status: 419 # unofficial timeout status code
			end
		
			rescue_from JWT::ExpiredSignature do
				render json: { error: 'Token vencido' }, status: 419 # unofficial timeout status code
			end

			private

			# Based on the user_id inside the token payload, find the user.
			def set_current_user
				if decoded_auth_token
					@current_user ||= Usuario.find(decoded_auth_token['user_id'])
				end
			end

			# Check to make sure the current user was set and the token is not expired
			def authenticate_request
				if auth_token_expired?
					fail Exceptions::AuthenticationTimeoutError
				elsif !@current_user
					fail Exceptions::NotAuthenticatedError
				end
			end

			def decoded_auth_token
				@decoded_auth_token ||= AuthToken.decode(http_auth_header_content)
			end

			def auth_token_expired?
				false && decoded_auth_token && decoded_auth_token.expired?
			end

			# JWT's are stored in the Authorization header using this format:
			# Bearer somerandomstring.encoded-payload.anotherrandomstring
			def http_auth_header_content
				return @http_auth_header_content if defined? @http_auth_header_content
				@http_auth_header_content = begin
					if request.headers['Authorization'].present?
						request.headers['Authorization'].split(' ').last
					else
						nil
					end
				end
				return @http_auth_header_content
			end

			protected
 
			# CanCanCan: derive the model nombre from the controller. egs UsersController will return User
			def self.permiso
				return nombre = self.nombre.gsub('Controller','').singularize.split('::').last.constantize.nombre rescue nil
			end

			# CanCanCan: 
			def current_ability
				@current_ability ||= Ability.new(@current_user)
			end

			# CanCanCan: carga los permisos del usuario actual
			def cargar_permisos
				@permisos_de_usuario = @current_user.rol.permisos.collect{|i| i.nombre}
			end
		end
	end
end
