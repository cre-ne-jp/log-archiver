APP_PATH = File.expand_path('../../config/application', __FILE__)
require_relative '../config/boot'

options = { environment: (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || "development").dup }
ENV["RAILS_ENV"] = options[:environment]

require APP_PATH
Rails.application.require_environment!
Rails.application.load_runner
