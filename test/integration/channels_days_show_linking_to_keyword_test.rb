# frozen_string_literal: true

require 'test_helper'

class ChannelsDaysShowLinkingToKeywordTest < ActionDispatch::IntegrationTest
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

  test 'キーワードのリンク先および表記が正しい' do
    # メッセージとキーワードを関連付ける
    @privmsgs.each do |privmsg|
      LogArchiver::ExtractKeyword.run(privmsg)
    end

    # すべてのメッセージが同じキーワードと関連付けられていることを確認する
    @privmsgs.each do |privmsg|
      assert_equal(@keyword.id, privmsg.keyword.id,
                   %Q|"#{privmsg.message}: 対応するキーワードが正しい"|)
    end

    # 1日ごとのログページを閲覧する

    date = @privmsgs[0].timestamp.to_date
    channel = @privmsgs[0].channel
    @browse = ChannelBrowse::Day.new(channel: channel,
                                     date: date,
                                     style: :normal)

    get(@browse.path)

    # キーワード部分のリンク先が正しいことを確認する
    @privmsgs.each do |privmsg|
      assert_select("##{privmsg.fragment_id} .message dd a", 1) do |links|
        assert_equal(keyword_path(privmsg.keyword), links[0]['href'],
                     %Q|"#{privmsg.message.inspect}: キーワード部分のリンク先が正しい"|)
      end
    end

    # メッセージの表記が正しいことを確認する
    @privmsgs.each do |privmsg|
      assert_select("##{privmsg.fragment_id} .message dd", 1) do |elements|
        assert_equal(privmsg.message, elements[0].content,
                     %Q|"#{privmsg.message.inspect}: メッセージの表記が正しい"|)
      end
    end
  end
end
