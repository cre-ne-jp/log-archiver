ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# CI環境では事前にテスト用データベースのマイグレーションを行うため
# テスト前のデータベースの準備を行わないようにする
ActiveRecord::Base.maintain_test_schema = false

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

require 'factory_bot_rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  include Sorcery::TestHelpers::Rails::Integration

  def login_user(user)
    post(
      user_sessions_path,
      params: {
        username: user.username,
        password: 'pa$$word'
      }
    )
    follow_redirect!
  end

  def logout_user
    get(logout_path)
    follow_redirect!
  end
end
