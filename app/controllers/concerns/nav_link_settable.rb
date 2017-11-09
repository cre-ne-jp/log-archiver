# prev・nextといったナビゲーション用のメタ情報の設定が行えるモジュール
module NavLinkSettable
  extend ActiveSupport::Concern

  # 前のページへのリンクのメタ情報を設定する
  # @param [#path] browse_prev 前のページの閲覧
  #
  # browse_prev が偽の場合は何もしない。
  def set_prev_link!(browse_prev)
    set_nav_link!(:prev, browse_prev)
  end

  # 次のページへのリンクのメタ情報を設定する
  # @param [#path] browse_next 次のページの閲覧
  #
  # browse_next が偽の場合は何もしない。
  def set_next_link!(browse_next)
    set_nav_link!(:next, browse_next)
  end

  private

  # リンクのメタ情報を設定する
  # @param [Symbol] type リンクの種類
  # @param [#path] browse ページの閲覧
  #
  # browse 偽の場合は何もしない。
  def set_nav_link!(type, browse)
    set_meta_tags(type => browse.path) if browse
  end
end
