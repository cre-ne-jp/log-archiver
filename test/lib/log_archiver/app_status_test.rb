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

    test '#version_and_commit_id: バージョンとコミットIDを表す文字列を返す' do
      assert_equal("#{VERSION} (#{DUMMY_COMMIT_ID})",
                   @app_status.version_and_commit_id)
    end

    test '#version_and_commit_id: コミットIDがない場合、バージョンのみが含まれる文字列を返す' do
      app_status_without_commit_id = AppStatus.new(DUMMY_START_TIME, nil)
      assert_equal(VERSION, app_status_without_commit_id.version_and_commit_id)
    end

    test '.format_uptime: 1秒' do
      assert_equal('0:00:00:01', AppStatus.format_uptime(1))
    end

    test '.format_uptime: 1分23秒' do
      assert_equal('0:00:01:23', AppStatus.format_uptime(1 * 60 + 23))
    end

    test '.format_uptime: 1時間23分45秒' do
      assert_equal('0:01:23:45',
                   AppStatus.format_uptime((1 * 60 * 60) + (23 * 60) + 45))
    end

    test '.format_uptime: 1日2時間3分4秒' do
      assert_equal('1:02:03:04',
                   AppStatus.format_uptime((1 * 24 * 60 * 60) +
                                           (2 * 60 * 60) + (3 * 60) + 4))
    end

    test '.format_uptime: 12日23時間34分56秒' do
      assert_equal('12:23:34:56',
                   AppStatus.format_uptime((12 * 24 * 60 * 60) +
                                           (23 * 60 * 60) + (34 * 60) + 56))
    end
  end
end
