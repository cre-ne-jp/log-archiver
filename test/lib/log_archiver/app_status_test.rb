require 'test_helper'

module LogArchiver
  # アプリケーションの状態を表すクラスのテスト
  class AppStatusTest < ActiveSupport::TestCase
    # ダミーの起動時刻
    DUMMY_START_TIME = Time.new(2019, 4, 1, 12, 34, 56, '+09:00')
    # ダミーのコミットID
    DUMMY_COMMIT_ID = '0123456789abcdef0123456789abcdef01234567'

    setup do
      @app_status = AppStatus.new(DUMMY_START_TIME, DUMMY_COMMIT_ID)
    end

    test '#start_time は起動時刻を返す' do
      assert_equal(DUMMY_START_TIME, @app_status.start_time)
    end

    test '#commit_id はコミットIDを返す' do
      assert_equal(DUMMY_COMMIT_ID, @app_status.commit_id)
    end
  end
end
