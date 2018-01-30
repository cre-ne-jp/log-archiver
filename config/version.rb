# vim: fileencoding=utf-8

module LogArchiver
  class Application
    # Log Archiverのバージョン
    VERSION = '0.3.2'

    # バージョンとコミットIDを表す文字列を返す
    # @return [String]
    #
    # コミットID取得時にエラーが発生した場合は、返り値にコミットIDが含まれない。
    def self.version_and_commit_id
      commit_id =
        begin
          Dir.chdir(root) do
            `git show -s --format=%H`.strip
          end
        rescue
          ''
        end

      commit_id.empty? ? VERSION : "#{VERSION} (#{commit_id})"
    end
  end
end
