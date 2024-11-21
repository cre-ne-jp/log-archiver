# frozen_string_literal: true

=begin
# Sidekiq 7.x 系列からは、テスト内で接続設定を変更できなくなった。
# しかし、6.x 系列が依存している rack の更新がされなくなるため、このテストを
# 実施しないようにする。

require 'test_helper'
require 'user_login_test_helper'

# Redisに接続できない場合の「現在の状態」画面の結合テスト
class AdminStatusShowWithoutRedisTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    @user = create(:user)

    @login_helper = UserLoginTestHelper.new(self, @user, admin_status_path)

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:63790/0' }
    end
  end

  teardown do
    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
    end
  end

  test 'ログインしている場合、表示される' do
    @login_helper.assert_successful_login_and_get
  end

  test 'Redis未起動のエラーメッセージが表示される' do
    @login_helper.assert_successful_login_and_get
    assert_select('.sidekiq-stats .alert-danger')
  end
end
=end
