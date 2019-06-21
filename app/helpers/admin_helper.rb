module AdminHelper
  # コミットIDを整形する
  # @param [String] commit_id コミットID
  # @return [String] コミットIDがあれば、そのまま返す
  # @return [String] コミットIDが空文字列ならば "-"
  def format_commit_id(commit_id)
    commit_id.empty? ? '-' : commit_id
  end
end
