# vim: fileencoding=utf-8

module LogArchiver
  class Application
    # Log Archiverのバージョン
    VERSION = '0.5.1'

    # コミットIDのキャッシュ用
    # @return [String]
    COMMIT_ID =
      begin
        Dir.chdir(root) do
          `git show -s --format=%H`.strip
        end
      rescue
        ''
      end

    # バージョンとコミットIDのキャッシュ用
    # @return [String]
    VERSION_AND_COMMIT_ID = (COMMIT_ID != '') ? "#{VERSION} (#{COMMIT_ID})" : VERSION

    def self.commit_id
      @@commit_id
    end

    # バージョンとコミットIDを表す文字列を返す
    # @return [String]
    #
    # コミットID取得時にエラーが発生した場合は、返り値にコミットIDが含まれない。
    #
    # 一度実行したときに結果をキャッシュする。
    # これは、再起動しない限り読み込まれたコードは更新されず、
    # 実質的に初回実行時とバージョンが変わらないため。
    # また、そのようにすることで、gitが何回も実行されるのを防ぐことができる。
    def self.version_and_commit_id
=begin
      # 結果がキャッシュされていた場合は、それを返す
      return @@version_and_commit_id if @@version_and_commit_id

      @@commit_id =
        begin
          Dir.chdir(root) do
            `git show -s --format=%H`.strip
          end
        rescue
          ''
        end

      @@version_and_commit_id =
        @@commit_id.empty? ? VERSION : "#{VERSION} (#{@@commit_id})"
=end
      @@version_and_commit_id
    end
  end
end
