require 'test_helper'
require 'application_system_test_case'

class MessagesSearchTest < ApplicationSystemTestCase
  setup do
    create(:setting)

    ConversationMessage.delete_all
    @privmsg = create(:privmsg)
  end

  teardown do
    ConversationMessage.delete_all
  end

  test '検索結果が正しく表示される' do
    visit(messages_search_url(q: 'メッセージ'))

    assert_selector('h2', exact_text: '2016-04-01')

    # 検索結果が1件のみ
    assert_selector('.message-type-privmsg', count: 1)

    within('.message-type-privmsg') do
      assert_selector('dt', exact_text: 'rgrb')
      assert_selector('dd', exact_text: 'プライベートメッセージ')

      within('.message-channel') do
        assert(has_link?('#irc_test', exact: true, href: channel_path('irc_test')))
      end
    end
  end

  test '該当なしの場合にメッセージが表示される' do
    visit(messages_search_url(q: 'message'))

    within('.main-panel') do
      assert_text('該当するメッセージは見つかりませんでした。')
    end
  end
end
