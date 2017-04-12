require 'test_helper'

class MessageSearchTest < ActiveSupport::TestCase
  setup do
    @search = build(:message_search)

    ConversationMessage.delete_all
  end

  teardown do
    ConversationMessage.delete_all
  end

  test '有効である' do
    assert(@search.valid?)
  end

  test 'query または nick は必須' do
    @search.query = @search.nick = nil
    refute(@search.valid?)
  end

  test 'query および nick が空白のみではならない' do
    @search.query = @search.nick = ' ' * 10
    refute(@search.valid?)
  end

  test 'query のみは有効' do
    @search.nick = ''
    assert(@search.valid?)
  end

  test 'nick のみは有効' do
    @search.query = ''
    assert(@search.valid?)
  end

  test 'since と until が共に存在する場合、until は since 以上' do
    @search.since = Date.new(2017, 1, 1)

    @search.until = Date.new(2017, 1, 2)
    assert(@search.valid?, 'since < until は有効')

    @search.until = Date.new(2017, 1, 1)
    assert(@search.valid?, 'since == until は有効')

    @search.until = Date.new(2016, 12, 31)
    refute(@search.valid?, 'since > until は無効')
  end

  test 'attributes が正しい' do
    attributes = @search.attributes

    assert_equal(@search.query, attributes.fetch('query'), 'query')
    assert_equal(@search.nick, attributes.fetch('nick'), 'nick')
    assert_equal(@search.channels, attributes.fetch('channels'), 'channels')
    assert_equal(@search.since, attributes.fetch('since'), 'since')
    assert_equal(@search.until, attributes.fetch('until'), 'until')
    assert_equal(@search.page, attributes.fetch('page'), 'page')
  end

  test 'attributes= によって属性が正しく設定される' do
    channels = %i(channel channel_with_camel_case_name).
      map { |factory| create(factory) }
    channel_identifiers = channels.map(&:identifier)

    attributes = {
      'query' => 'test',
      'nick' => 'foo',
      'channels' => channel_identifiers,
      'since' => Date.new(2000, 1, 23),
      'until' => Date.new(2001, 12, 31),
      'page' => 12
    }

    @search.attributes = attributes

    assert_equal(attributes['query'], @search.query, 'query')
    assert_equal(attributes['nick'], @search.nick, 'nick')
    assert_equal(attributes['channels'], @search.channels, 'channels')
    assert_equal(attributes['since'], @search.since, 'since')
    assert_equal(attributes['until'], @search.until, 'until')
    assert_equal(attributes['page'], @search.page, 'page')
  end

  test 'attributes_for_result_page が正しい' do
    attributes = @search.attributes_for_result_page

    assert_equal(@search.query, attributes.fetch('q'), 'query')
    assert_equal(@search.nick, attributes.fetch('nick'), 'nick')
    assert_equal(@search.channels.join(' '), attributes.fetch('channels'), 'channels')
    assert_equal(@search.since&.strftime('%F'), attributes.fetch('since'), 'since')
    assert_equal(@search.until&.strftime('%F'), attributes.fetch('until'), 'until')
    assert_equal(@search.page, attributes.fetch('page'), 'page')
  end

  test 'set_attributes_with_result_page_params によって属性が正しく設定される' do
    channels = %w(channel channel_with_camel_case_name).
      map { |factory| create(factory) }
    channel_identifiers = channels.map(&:identifier)
    attributes = {
      'q' => 'test',
      'nick' => 'foo',
      'channels' => channel_identifiers.join(' '),
      'since' => '2000-01-23',
      'until' => '2001-12-31',
      'page' => 12
    }

    @search.set_attributes_with_result_page_params(attributes)

    assert_equal(attributes['q'], @search.query, 'query')
    assert_equal(attributes['nick'], @search.nick, 'nick')
    assert_equal(channel_identifiers, @search.channels, 'channel')
    assert_equal(attributes['since'].to_date, @search.since, 'since')
    assert_equal(attributes['until'].to_date, @search.until, 'until')
    assert_equal(attributes['page'], @search.page, 'page')
  end

  def prepare_messages_for_search
    @privmsg_rgrb_20140320012345 = create(:privmsg_rgrb_20140320012345)
    @privmsg_role_20140320023456 = create(:privmsg_role_20140320023456)
    @privmsg_toybox_20140320210954 = create(:privmsg_toybox_20140320210954)

    @notice_toybox_20140320000000 = create(:notice_toybox_20140320000000)
    @notice_toybox_20140321000000 = create(:notice_toybox_20140321000000)

    @topic_toybox_20140320233223 = create(:topic_toybox_20140320233223)
    @topic_toybox_20140321134507 = create(:topic_toybox_20140321134507)

    assert(6, ConversationMessage.count)
  end

  test '検索文字列を指定した場合の検索結果が正しい' do
    prepare_messages_for_search

    @search.query = 'irc.cre.jp'
    @search.nick = ''
    @search.since = nil
    @search.until = nil
    @search.page = 1

    result = @search.result
    result_ids = result.messages.map(&:id)

    assert_equal(4, result.messages.length)
    assert_includes(result_ids, @privmsg_rgrb_20140320012345.id, 'RGRBのPRIVMSGが含まれる')
    assert_includes(result_ids, @privmsg_toybox_20140320210954.id, 'ToyboxのPRIVMSGが含まれる')
    assert_includes(result_ids, @topic_toybox_20140320233223.id, 'Toyboxの2014-03-20のTOPICが含まれる')
    assert_includes(result_ids, @topic_toybox_20140321134507.id, 'Toyboxの2014-03-21のTOPICが含まれる')
  end

  test 'ニックネームを指定した場合の検索結果が正しい' do
    prepare_messages_for_search

    @search.query = ''
    @search.nick = 'Toybox'
    @search.since = nil
    @search.until = nil
    @search.page = 1

    result = @search.result
    result_ids = result.messages.map(&:id)

    assert_equal(5, result.messages.length)
    assert_includes(result_ids, @privmsg_toybox_20140320210954.id, 'ToyboxのPRIVMSGが含まれる')
    assert_includes(result_ids, @notice_toybox_20140320000000.id, 'Toyboxの2014-03-20の時報のNOTICEが含まれる')
    assert_includes(result_ids, @notice_toybox_20140321000000.id, 'Toyboxの2014-03-21の時報のNOTICEが含まれる')
    assert_includes(result_ids, @topic_toybox_20140320233223.id, 'ToyboxのTOPICが含まれる')
    assert_includes(result_ids, @topic_toybox_20140321134507.id, 'Toyboxの2014-03-21のTOPICが含まれる')
  end

  test '検索文字列とニックネームを指定した場合の検索結果が正しい' do
    prepare_messages_for_search

    @search.query = 'irc.cre.jp'
    @search.nick = 'Toybox'
    @search.since = nil
    @search.until = nil
    @search.page = 1

    result = @search.result
    result_ids = result.messages.map(&:id)

    assert_equal(3, result.messages.length)
    assert_includes(result_ids, @privmsg_toybox_20140320210954.id, 'ToyboxのPRIVMSGが含まれる')
    assert_includes(result_ids, @topic_toybox_20140320233223.id, 'Toyboxの2014-03-20のTOPICが含まれる')
    assert_includes(result_ids, @topic_toybox_20140321134507.id, 'Toyboxの2014-03-21のTOPICが含まれる')
  end

  test '検索文字列とニックネームと日付を指定した場合の検索結果が正しい' do
    prepare_messages_for_search

    @search.query = ''
    @search.nick = 'Toybox'
    @search.since = '2014-03-20'
    @search.until = '2014-03-20'
    @search.page = 1

    result = @search.result
    result_ids = result.messages.map(&:id)

    assert_equal(2, result.messages.length)
    assert_includes(result_ids, @privmsg_toybox_20140320210954.id, 'ToyboxのPRIVMSGが含まれる')
    assert_includes(result_ids, @topic_toybox_20140320233223.id, 'Toyboxの2014-03-20のTOPICが含まれる')
  end
end
