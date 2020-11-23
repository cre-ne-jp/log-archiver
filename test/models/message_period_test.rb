require 'test_helper'

# 期間指定モデルのテスト
# @todo NICKやQUITがまとめられることを確認するテストを追加したい。
class MessagePeriodTest < ActiveSupport::TestCase
  setup do
    @period = build(:message_period)

    Message.delete_all
    ConversationMessage.delete_all
  end

  teardown do
    ConversationMessage.delete_all
    Message.delete_all
  end

  test '有効である' do
    assert(@period.valid?)
  end

  test 'since と until が共に存在する場合、until は since 以上' do
    @period.since = Time.new(2017, 1, 1)

    @period.until = Time.new(2017, 1, 2)
    assert(@period.valid?, 'since < until は有効')

    @period.until = Time.new(2017, 1, 1)
    assert(@period.valid?, 'since == until は有効')

    @period.until = Time.new(2016, 12, 31)
    refute(@period.valid?, 'since > until は無効')
  end

  test 'attributes が正しい' do
    attributes = @period.attributes

    assert_equal(%w(channel_100 channel_200), attributes.fetch('channels'), 'channels')
    assert_equal(Time.new(2001, 2, 3, 4, 5, 6), attributes.fetch('since'), 'since')
    assert_equal(Time.new(2002, 3, 4, 12, 34, 56), attributes.fetch('until'), 'until')
    assert_equal(2, attributes.fetch('page'), 'page')
  end

  test 'attributes= によって属性が正しく設定される' do
    %i(channel channel_with_camel_case_name).each do |factory|
      create(factory)
    end

    attributes = {
      'channels' => %w(channel camel_case_channel),
      'since' => Time.new(2000, 1, 23, 4, 56, 7),
      'until' => Time.new(2001, 12, 31, 7, 8, 9),
      'page' => 12
    }

    @period.attributes = attributes

    assert_equal(attributes['channels'], @period.channels, 'channels')
    assert_equal(attributes['since'], @period.since, 'since')
    assert_equal(attributes['until'], @period.until, 'until')
    assert_equal(attributes['page'], @period.page, 'page')
  end

  test 'attributes_for_result_page が正しい' do
    attributes = @period.attributes_for_result_page

    assert_equal('channel_100 channel_200', attributes.fetch('channels'), 'channels')
    assert_equal('2001-02-03 04:05:06', attributes.fetch('since'), 'since')
    assert_equal('2002-03-04 12:34:56', attributes.fetch('until'), 'until')
    assert_equal(2, attributes.fetch('page'), 'page')
  end

  test 'set_attributes_with_result_page_params によって属性が正しく設定される' do
    %i(channel channel_with_camel_case_name).each do |factory|
      create(factory)
    end

    attributes = {
      'channels' => 'channel camel_case_channel',
      'since' => '2000-01-23 04:56:07',
      'until' => '2001-12-31 07:08:09',
      'page' => 12
    }

    @period.set_attributes_with_result_page_params(attributes)

    assert_equal(['channel', 'camel_case_channel'], @period.channels, 'channel')
    assert_equal(Time.new(2000, 1, 23, 4, 56, 7), @period.since, 'since')
    assert_equal(Time.new(2001, 12, 31, 7, 8, 9), @period.until, 'until')
    assert_equal(12, @period.page, 'page')
  end

  # テストで使うメッセージの準備を行う
  #
  # 全体的に通常の逆順にして、IDの影響を見られるようにする。
  def prepare_messages
    # Messageの準備

    # 最初のJOIN
    @join_role_channel_200_20200320023455 = create(:join_role_channel_200_20200320023455)
    @join_role_channel_100_20200320023455 = create(:join_role_channel_100_20200320023455)

    # NICK
    @nick_role_channel_200_20200320023501 = create(:nick_role_channel_200_20200320023501)
    @nick_role_channel_100_20200320023501 = create(:nick_role_channel_100_20200320023501)

    # PART
    @part_role_channel_200_20200320023601 = create(:part_role_channel_200_20200320023601)
    @part_role_channel_100_20200320023601 = create(:part_role_channel_100_20200320023601)

    # 2回目のJOIN
    @join_role_channel_200_20200320023730 = create(:join_role_channel_200_20200320023730)
    @join_role_channel_100_20200320023701 = create(:join_role_channel_100_20200320023701)

    # QUIT
    @quit_rgrb_channel_100_20200321112233 = create(:quit_rgrb_channel_100_20200321112233)
    @quit_role_channel_200_20200320024001 = create(:quit_role_channel_200_20200320024001)
    @quit_role_channel_100_20200320024001 = create(:quit_role_channel_100_20200320024001)

    # PRIVMSG
    @privmsg_toybox_channel_300_20200320210954 = create(:privmsg_toybox_channel_300_20200320210954)
    @privmsg_role_channel_200_20200320023456 = create(:privmsg_role_channel_200_20200320023456)
    @privmsg_rgrb_channel_100_20200320012345 = create(:privmsg_rgrb_channel_100_20200320012345)

    # NOTICE
    @notice_toybox_channel_300_20200321000000 = create(:notice_toybox_channel_300_20200321000000)
    @notice_toybox_channel_300_20200320000000 = create(:notice_toybox_channel_300_20200320000000)

    assert_equal(11, Message.count)
    assert_equal(5, ConversationMessage.count)
  end

  test '開始日時を指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = []
    @period.since = Time.new(2020, 3, 20, 12, 0, 0, '+09:00')
    @period.until = nil
    @period.page = 1

    result = @period.result

    assert_equal(
      [
        @quit_rgrb_channel_100_20200321112233,
      ],
      result.messages.to_a
    )

    assert_equal(
      [
        @privmsg_toybox_channel_300_20200320210954,
        @notice_toybox_channel_300_20200321000000,
      ],
      result.conversation_messages.to_a
    )
  end

  test '終了日時を指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = []
    @period.since = nil
    @period.until = Time.new(2020, 3, 20, 2, 36, 0, '+09:00')
    @period.page = 1

    result = @period.result

    assert_equal(
      [
        @join_role_channel_200_20200320023455,
        @join_role_channel_100_20200320023455,
        @nick_role_channel_200_20200320023501,
        @nick_role_channel_100_20200320023501,
      ],
      result.messages.to_a
    )

    assert_equal(
      [
        @notice_toybox_channel_300_20200320000000,
        @privmsg_rgrb_channel_100_20200320012345,
        @privmsg_role_channel_200_20200320023456,
      ],
      result.conversation_messages.to_a
    )
  end

  test '開始日時と終了日時の両方を指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = []
    @period.since = Time.new(2020, 3, 20, 1, 0, 0, '+09:00')
    @period.until = Time.new(2020, 3, 20, 2, 35, 0, '+09:00')
    @period.page = 1

    result = @period.result

    assert_equal(
      [
        @join_role_channel_200_20200320023455,
        @join_role_channel_100_20200320023455,
      ],
      result.messages.to_a
    )

    assert_equal(
      [
        @privmsg_rgrb_channel_100_20200320012345,
        @privmsg_role_channel_200_20200320023456,
      ],
      result.conversation_messages.to_a
    )
  end

  test 'チャンネルを指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = %w(channel_200 channel_300)
    @period.since = nil
    @period.until = nil
    @period.page = 1

    result = @period.result

    assert_equal(
      [
        @join_role_channel_200_20200320023455,
        @nick_role_channel_200_20200320023501,
        @part_role_channel_200_20200320023601,
        @join_role_channel_200_20200320023730,
        @quit_role_channel_200_20200320024001,
      ],
      result.messages.to_a
    )

    assert_equal(
      [
        @notice_toybox_channel_300_20200320000000,
        @privmsg_role_channel_200_20200320023456,
        @notice_toybox_channel_300_20200321000000,
      ],
      result.conversation_messages.to_a
    )
  end

  test 'チャンネル、開始日時、終了日時を指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = %w(channel_200 channel_300)
    @period.since = Time.new(2020, 3, 20, 0, 0, 0, '+09:00')
    @period.until = Time.new(2020, 3, 20, 2, 36, 0, '+09:00')
    @period.page = 1

    result = @period.result

    assert_equal(
      [
        @join_role_channel_200_20200320023455,
        @nick_role_channel_200_20200320023501,
      ],
      result.messages.to_a
    )

    assert_equal(
      [
        @notice_toybox_channel_300_20200320000000,
        @privmsg_role_channel_200_20200320023456,
      ],
      result.conversation_messages.to_a
    )
  end
end
