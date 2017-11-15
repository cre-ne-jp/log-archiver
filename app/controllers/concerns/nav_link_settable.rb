# prev・nextといったナビゲーション用のメタ情報の設定が行えるモジュール
module NavLinkSettable
  extend ActiveSupport::Concern

  # 前のページへのリンクのメタ情報を設定する
  # @param [String, #path] href 前のページ
  # @return [void]
  #
  # href が偽の場合は何もしない。
  def set_prev_link!(href)
    set_nav_link!(:prev, href)
  end

  # 次のページへのリンクのメタ情報を設定する
  # @param [String, #path] href 次のページ
  # @return [void]
  #
  # href が偽の場合は何もしない。
  def set_next_link!(href)
    set_nav_link!(:next, href)
  end

  private

  # リンクのメタ情報を設定する
  # @param [Symbol] type リンクの種類
  # @param [String, #path] href リンク先
  # @return [void]
  #
  # href が偽の場合は何もしない。
  def set_nav_link!(type, href)
    return unless href

    path =
      case href
      when String
        href
      when ->x { x.respond_to?(:path) }
        href.path
      else
        raise ArgumentError, "could not linkify: #{href}"
      end

    set_meta_tags(type => path)
  end
end
