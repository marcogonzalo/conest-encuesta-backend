ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

namespace :db do
  namespace :test do
    task :load => :environment do
      Rake::Task["db:seed"].invoke
    end
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
	#load "#{Rails.root}/db/seeds/roles.seeds.rb"
	#load "#{Rails.root}/db/seeds/permisos.seeds.rb"
	#load "#{Rails.root}/db/seeds/permisos_roles.seeds.rb"

  # Add more helper methods to be used by all tests here...
	def get_context(request,response=nil)
		puts "\n\nRequest:\n#{request.params}"
		if response
			puts "\nResponse:\nCode: #{response.code}"
			puts "Body: #{response.body}" unless response.body.empty?
		end
		puts "\n\n"
	end
end

