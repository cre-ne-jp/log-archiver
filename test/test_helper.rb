ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/mock'

require 'simplecov'
# カバレッジ測定開始
SimpleCov.start do
  # ライブラリを無視する
  add_filter('/vendor/')
end

require 'minitest/reporters'
Minitest::Reporters.use!

require 'factory_girl_rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
end

class ActionDispatch::IntegrationTest
   def login_user(user)
    post(user_sessions_path, username: user.username, password: 'pa$$word')
    follow_redirect!
   end

   def logout_user
     get(logout_path)
     follow_redirect!
   end
end
