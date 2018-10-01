require 'test_helper'

class MessagesSearchTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)

    ConversationMessage.delete_all
    @privmsg = create(:privmsg)
  end

  teardown do
    ConversationMessage.delete_all
  end

  test '検索結果が正しく表示される' do
    get(
      messages_search_path,
      params: {
        q: 'メッセージ'
      }
    )
    assert_response(:success)

    assert_select('h2', '2016-04-01', '日付の見出しが存在する')

    # 検索結果が1件のみ
    assert_select('.message-type-privmsg', 1)

    assert_select('.message-type-privmsg') do
      assert_select('dt', 'rgrb', 'ニックネームが正しい')
      assert_select('dd', 'プライベートメッセージ', 'メッセージが正しい')
    end

    channel = css_select('.message-type-privmsg > .message-channel').first
    refute_nil(channel, 'チャンネル欄が存在する')

    assert_equal('#irc_test', channel.content, 'チャンネルの表示が正しい')

    link_for_channel = channel.at_css('a')
    refute_nil(link_for_channel, 'チャンネルへのリンクが存在する')

    assert_equal('/channels/irc_test', link_for_channel['href'], 'チャンネルへのリンクのリンク先が正しい')
  end
end
