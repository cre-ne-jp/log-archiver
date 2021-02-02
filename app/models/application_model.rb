class ApplicationModel
  include ActiveModel::Model

  # controller/application_controller
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
