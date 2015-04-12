module Api
	module V1
		class ApplicationController < ActionController::Base
		  # Prevent CSRF attacks by raising an exception.
		  # For APIs, you may want to use :null_session instead.
		  # protect_from_forgery with: :exception

			before_filter :set_access_control_headers

			def set_access_control_headers
				headers['Access-Control-Allow-Origin'] = 'http://localhost:9000'
				headers['Access-Control-Request-Method'] = 'GET, OPTIONS, HEAD, POST, PUT'
				headers['Access-Control-Allow-Headers'] = 'x-requested-with,Content-Type, Authorization'
			end
		end
	end
end
