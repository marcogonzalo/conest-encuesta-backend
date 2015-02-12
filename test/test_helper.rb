ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
	def get_context(request,response=nil)
		puts "\n\nRequest:\n#{request.params}"
		if response
			puts "\nResponse:\nCode: #{response.code}"
			puts"Body: #{response.body}" unless response.body.empty?
		end
		puts "\n\n"
	end
end
