# frozen_string_literal: true

require 'test_helper'

class ChannelsDaysShowLinkingToKeywordTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    create(:user)
    @channel = create(:channel)

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
    extract_keyword = LogArchiver::ExtractKeyword.new
    @privmsgs.each do |privmsg|
      extract_keyword.run(privmsg)
    end

    # すべてのメッセージが同じキーワードと関連付けられていることを確認する
    @privmsgs.each do |privmsg|
      assert_equal(@keyword.id, privmsg.keyword.id,
                   "#{privmsg.message.inspect}: 対応するキーワードが正しい")
    end

    # 1日ごとのログページを閲覧する

    @browse = ChannelBrowse::Day.new(channel: @channel,
                                     date: Date.new(2019, 10, 20),
                                     style: :normal)

    get(@browse.path)

    # キーワード部分のリンク先が正しいことを確認する

    expected_keyword_path = '/keywords/sword_world_2_0'

    assert_select('#c190465ea .message dd a', 1) do |links|
      assert_equal(expected_keyword_path, links[0]['href'],
                   '".k Sword World 2.0": キーワード部分のリンク先が正しい')
    end

    assert_select('#c4f6f174d .message dd a', 1) do |links|
      assert_equal(expected_keyword_path, links[0]['href'],
                   '".a Sword World 2.0": キーワード部分のリンク先が正しい')
    end

    assert_select('#c110eb57c .message dd a', 1) do |links|
      assert_equal(expected_keyword_path, links[0]['href'],
                   '".k SWORD WORLD 2.0": キーワード部分のリンク先が正しい')
    end

    assert_select('#c53c2aad9 .message dd a', 1) do |links|
      assert_equal(expected_keyword_path, links[0]['href'],
                   '".k　Ｓｗｏｒｄ　Ｗｏｒｌｄ　２．０": キーワード部分のリンク先が正しい')
    end

    # メッセージの表記が正しいことを確認する
    assert_select('#c190465ea .message dd',
                  { text: '.k Sword World 2.0', count: 1 },
                  '".k Sword World 2.0": キーワード部分のリンク先が正しい')

    assert_select('#c4f6f174d .message dd',
                  { text: '.a Sword World 2.0', count: 1 },
                  '".a Sword World 2.0": キーワード部分のリンク先が正しい')

    assert_select('#c110eb57c .message dd',
                  { text: '.k SWORD WORLD 2.0', count: 1 },
                  '".k SWORD WORLD 2.0": キーワード部分のリンク先が正しい')

    assert_select('#c53c2aad9 .message dd',
                  { text: '.k　Ｓｗｏｒｄ　Ｗｏｒｌｄ　２．０', count: 1 },
                  '".k　Ｓｗｏｒｄ　Ｗｏｒｌｄ　２．０": キーワード部分のリンク先が正しい')

    # ヘッダのキーワード一覧の表示が正しいことを確認する
    assert_select('#keyword-list td') do |td|
      assert_select(
        'a',
        { text: 'Sword World 2.0', count: 1 },
        'ヘッダ: キーワードへのリンクが存在する'
      ) do |links|
        assert_equal(expected_keyword_path, links[0]['href'],
                     'ヘッダ: キーワードのリンク先が正しい')
      end

      assert_select(
        'a',
        { text: '01:23:45', count: 1 },
        'ヘッダ: ".k Sword World 2.0": リンク（時刻表記）が存在する'
      ) do |links|
        assert_equal('#c190465ea', links[0]['href'],
                     'ヘッダ: ".k Sword World 2.0": リンク先が正しい')
      end

      assert_select(
        'a',
        { text: '01:23:55', count: 1 },
        'ヘッダ: ".a Sword World 2.0": リンク（時刻表記）が存在する'
      ) do |links|
        assert_equal('#c4f6f174d', links[0]['href'],
                     'ヘッダ: ".a Sword World 2.0": リンク先が正しい')
      end

      assert_select(
        'a',
        { text: '01:24:05', count: 1 },
        'ヘッダ: ".k SWORD WORLD 2.0": リンク（時刻表記）が存在する'
      ) do |links|
        assert_equal('#c110eb57c', links[0]['href'],
                     'ヘッダ: ".k SWORD WORLD 2.0": リンク先が正しい')
      end

      assert_select(
        'a',
        { text: '01:24:15', count: 1 },
        'ヘッダ: ".k　Ｓｗｏｒｄ　Ｗｏｒｌｄ　２．０": リンク（時刻表記）が存在する'
      ) do |links|
        assert_equal('#c53c2aad9', links[0]['href'],
                     'ヘッダ: ".k　Ｓｗｏｒｄ　Ｗｏｒｌｄ　２．０": リンク先が正しい')
      end

      assert_select('li',
                    /01:23:45\s+01:23:55\s+01:24:05\s+01:24:15/,
                    '時刻の順序が正しい')
    end
  end
end
