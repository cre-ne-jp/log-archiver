# frozen_string_literal: true

require 'time'

require 'log_archiver/version'

module LogArchiver
  # アプリケーションの状態を表すクラス
  class AppStatus
    # アプリケーションのバージョン
    # @return [String]
    attr_reader :version
    # アプリケーションの起動時刻
    # @return [Time]
    attr_reader :start_time
    # コミットID
    # @return [String]
    attr_reader :commit_id
    # バージョンとコミットIDを表す文字列
    # @return [String]
    attr_reader :version_and_commit_id

    # Gitを起動してコミットIDを取得する
    # @return [String] 取得したコミットID、取得できなかった場合は空文字列
    def self.get_commit_id
      begin
        Dir.chdir(Rails.application.root) do
          `git show -s --format=%H 2>/dev/null`.strip
        end
      rescue
        ''
      end
    end

    # 稼働時間を整形する
    # @param [Float] length_s 秒単位の稼働時間
    # @return [String] 整形後の稼働時間
    def self.format_uptime(length_s)
      # 日数、残りの秒数を求める
      # 24時間/日 * 60分/時間 * 60秒/分 = 86400秒/日
      day, rest_hms = length_s.divmod(86400)

      # 時間、残りの秒数を求める
      # 60分/時間 * 60秒/分 = 3600秒/時間
      hour, rest_ms = rest_hms.divmod(3600)

      # 分、秒を求める
      min, sec = rest_ms.divmod(60)

      '%d:%02d:%02d:%02d' % [day, hour, min, sec]
    end

    # アプリケーションの状態を表すHashから新しいインスタンスを作る
    # @param [Hash] hash アプリケーションの状態を表すHash
    def self.from_hash(hash)
      version = hash.dig(:version).to_s
      start_time = Time.at(hash.dig(:start_time))
      commit_id = hash.dig(:commit_id).to_s

      new(version, start_time, commit_id)
    end

    # アプリケーションの状態を初期化する
    # @param [String] version アプリケーションのバージョン
    # @param [Time] start_time アプリケーションの起動時刻
    # @param [String] commit_id コミットID
    def initialize(version, start_time, commit_id = '')
      @version = version.dup.freeze
      @start_time = start_time.dup.freeze
      @commit_id = commit_id.dup.freeze

      @version_and_commit_id =
        if commit_id.empty?
          version
        else
          "#{version} (#{commit_id})".freeze
        end
    end

    # アプリケーションの状態を表すHashを返す
    # @return [Hash]
    def to_h
      {
        version: version,
        commit_id: commit_id,
        start_time: start_time.to_f
      }
    end

    # 稼働時間を返す
    # @param [Time] current_time 現在の時刻
    # @return [Float]
    def uptime(current_time = Time.now)
      current_time - @start_time
    end

    # 整形された稼働時間を返す
    # @param [Time] current_time 現在の時刻
    # @return [String]
    def formatted_uptime(current_time = Time.now)
      AppStatus.format_uptime(uptime(current_time))
    end
  end
end
