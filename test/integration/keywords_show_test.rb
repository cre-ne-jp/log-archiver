require 'test_helper'

class KeywordsShowTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    create(:user)

    PrivmsgKeywordRelationship.delete_all
    Message.delete_all
    ConversationMessage.delete_all
    Keyword.delete_all

    @keyword = create(:keyword)

    # メッセージの準備

    privmsg_factory_ids = [
      :privmsg_keyword_sw_k,
      :privmsg_keyword_sw_a,
      :privmsg_keyword_sw_capital,
      :privmsg_keyword_sw_zenkaku
    ]
    @privmsgs = privmsg_factory_ids.map { |id| create(id) }
  end

  teardown do
    PrivmsgKeywordRelationship.delete_all
    Message.delete_all
    ConversationMessage.delete_all
    Keyword.delete_all
  end

  test 'キーワードを含む日が1つにまとめられる' do
    # メッセージとキーワードを関連付ける
    @privmsgs.each do |privmsg|
      LogArchiver::ExtractKeyword.new.run(privmsg)
    end

    # すべてのメッセージが同じキーワードと関連付けられていることを確認する
    @privmsgs.each do |privmsg|
      assert_equal(@keyword.id, privmsg.keyword.id,
                   %Q|"#{privmsg.message}: 対応するキーワードが正しい"|)
    end

    # キーワードの個別ページを閲覧する
    get(keyword_path(@keyword))

    assert_select('td.channel-date-date',
                  { text: '2019-10-20', count: 1 })
  end
end
