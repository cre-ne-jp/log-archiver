ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'test/unit/rails/test_help'
require 'active_support/testing/time_helpers'

require 'simplecov'
# カバレッジ測定開始
SimpleCov.start do
  # ライブラリを無視する
  add_filter('/vendor/')
end

require 'factory_bot_rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods

  include ActiveSupport::Testing::TimeHelpers

  # ファクトリーからオブジェクトを作成する
  # @param [Array<Symbol>] ids ファクトリーIDの配列
  # @return [Array<Object>] 作成されたオブジェクトの配列
  def create_with_factory_ids(*ids)
    ids.map { |id| create(id) }
  end
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
