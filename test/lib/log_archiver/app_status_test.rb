require 'test_helper'

module LogArchiver
  # アプリケーションの状態を表すクラスのテスト
  class AppStatusTest < ActiveSupport::TestCase
    # ダミーの起動時刻
    DUMMY_START_TIME = Time.new(2019, 4, 1, 12, 34, 56, '+09:00')

    # ダミーの稼働時間1（0:01:12:03経過）
    DUMMY_UPTIME_1 = (1 * 60 * 60) + (12 * 60) + 3
    # ダミーの現在時刻1（0:01:12:03経過）
    DUMMY_CURRENT_TIME_1 = DUMMY_START_TIME + DUMMY_UPTIME_1

    # ダミーの稼働時間2（12:23:34:45経過）
    DUMMY_UPTIME_2 = (12 * 24 * 60 * 60) + (23 * 60 * 60) + (34 * 60) + 45
    # ダミーの現在時刻2（12:23:34:45経過）
    DUMMY_CURRENT_TIME_2 = DUMMY_START_TIME + DUMMY_UPTIME_2

    # ダミーのコミットID
    DUMMY_COMMIT_ID = '0123456789abcdef0123456789abcdef01234567'

    setup do
      @app_status = AppStatus.new(DUMMY_START_TIME, DUMMY_COMMIT_ID)

      # Dir.chdir を書き換えるので、元のクラスメソッドを退避しておく
      Dir.singleton_class.class_eval do
        unless method_defined?(:chdir_original)
          alias :chdir_original :chdir
        end
      end
    end

    teardown do
      # 元の Dir.chdir に戻す
      Dir.singleton_class.class_eval do
        alias :chdir :chdir_original
      end
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

    test '#uptime: 0:01:12:03経過' do
      assert_equal(DUMMY_UPTIME_1, @app_status.uptime(DUMMY_CURRENT_TIME_1))
    end

    test '#uptime: 12:23:34:45経過' do
      assert_equal(DUMMY_UPTIME_2, @app_status.uptime(DUMMY_CURRENT_TIME_2))
    end

    test '#formatted_uptime: 0:01:12:03経過' do
      assert_equal('0:01:12:03',
                   @app_status.formatted_uptime(DUMMY_CURRENT_TIME_1))
    end

    test '#formatted_uptime: 12:23:34:45経過' do
      assert_equal('12:23:34:45',
                   @app_status.formatted_uptime(DUMMY_CURRENT_TIME_2))
    end

    test '.get_commit_id: コミットIDを取得できる' do
      `git log -1 > /dev/null 2>&1`
      unless $?.success?
        skip('コミットIDを取得できない環境です')
      end

      assert_match(/\A\h{40}\z/, AppStatus.get_commit_id)
    end

    test '.get_commit_id: コミットIDを取得できない場合、空文字列が返る' do
      Dir.chdir('/') do
        `git log -1 > /dev/null 2>&1`
        if $?.success?
          skip('ルートディレクトリがGitリポジトリになっています')
        end
      end

      Dir.singleton_class.class_eval do
        # 強制的にルートディレクトリに移動する
        def chdir(_, &b)
          chdir_original('/', &b)
        end
      end

      assert_equal('', AppStatus.get_commit_id)
    end
  end
end
