class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # 認証されていない場合の処理
  #
  # ログイン画面にリダイレクトする。
  def not_authenticated
    flash[:warning] = t('views.flash.login_first')
    redirect_to(login_path)
  end

  # PRIVMSG-キーワードの関連をConversationMessageの集合から抽出する
  # @param [Array<ConversationMessage>] messages ConversationMessageの配列
  # @return [Array<PrivmsgKeywordRelationship>]
  def privmsg_keyword_relationships_from(messages)
    privmsgs = messages.to_a.select { |m| m.kind_of?(Privmsg) }
    PrivmsgKeywordRelationship
      .includes(:keyword)
      .from_privmsgs(privmsgs)
      .to_a
  end
end
