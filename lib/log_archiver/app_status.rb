module LogArchiver
  # アプリケーションの状態を表すクラス
  class AppStatus
    # アプリケーションの起動時刻
    # @return [Time]
    attr_reader :start_time
    # コミットID
    # @return [String, nil]
    attr_reader :commit_id
    # バージョンとコミットIDを表す文字列
    # @return [String]
    attr_reader :version_and_commit_id

    # Gitを起動してコミットIDを取得する
    # @return [String] 取得したコミットID
    # @return [nil] コミットIDを取得できなかった場合はnil
    def self.get_commit_id
      raise NotImplementedError
    end

    # 稼働時間を整形する
    # @param [Float] length_s 秒単位の稼働時間
    # @return [String] 整形後の稼働時間
    def self.format_uptime(length_s)
      raise NotImplementedError
    end

    # アプリケーションの状態を初期化する
    # @param [Time] start_time アプリケーションの起動時刻
    # @param [String, nil] commit_id コミットID
    def initialize(start_time, commit_id = nil)
      @start_time = start_time
      @commit_id = commit_id

      @version_and_commit_id = commit_id ? "#{VERSION} (#{commit_id})" : VERSION
    end

    # 稼働時間を返す
    # @param [Time] current_time 現在の時刻
    # @return [Float]
    def uptime(current_time = Time.now)
      raise NotImplementedError
    end

    # 整形された稼働時間を返す
    # @param [Time] current_time 現在の時刻
    # @return [String]
    def formatted_uptime(current_time = Time.now)
      raise NotImplementedError
    end
  end
end
