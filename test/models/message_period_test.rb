require 'test_helper'

class MessagePeriodTest < ActiveSupport::TestCase
  setup do
    @period = build(:message_period)

    Message.delete_all
    ConversationMessage.delete_all
  end

  teardown do
    Message.delete_all
    ConversationMessage.delete_all
  end

  test '有効である' do
    assert(@period.valid?)
  end

  test 'channels は必須' do
    @period.channels = []
    refute(@period.valid?)

    @period.channels = nil
    refute(@period.valid?)
  end

  test 'since または until は必須' do
    @period.since = @period.until = nil
    refute(@period.valid?)
  end

  test 'since のみは有効' do
    @period.until = nil
    assert(@period.valid?)
  end

  test 'until のみは有効' do
    @period.since = nil
    assert(@period.valid?)
  end

  test 'since と until が共に存在する場合、until は since 以上' do
    @period.since = Time.zone.local(2017, 1, 1)

    @period.until = Time.zone.local(2017, 1, 2)
    assert(@period.valid?, 'since < until は有効')

    @period.until = Time.zone.local(2017, 1, 1)
    assert(@period.valid?, 'since == until は有効')

    @period.until = Time.zone.local(2016, 12, 31)
    refute(@period.valid?, 'since > until は無効')
  end

  test 'attributes が正しい' do
    attributes = @period.attributes

    assert_equal(%w(irc_test), attributes.fetch('channels'), 'channels')
    assert_equal(Time.zone.local(2001, 2, 3, 4, 56, 7), attributes.fetch('since'), 'since')
    assert_equal(Time.zone.local(2002, 3, 4, 5, 43, 21), attributes.fetch('until'), 'until')
  end

  test 'attributes= によって属性が正しく設定される' do
    attributes = {
      'channels' => %w(irc_test camel_case_channel),
      'since' => Time.zone.local(2000, 1, 23, 4, 5, 6),
      'until' => Time.zone.local(2001, 12, 31, 9, 8, 7),
    }

    @period.attributes = attributes

    assert_equal(attributes['channels'], @period.channels, 'channels')
    assert_equal(attributes['since'], @period.since, 'since')
    assert_equal(attributes['until'], @period.until, 'until')
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

  test 'チャンネルと開始日時を指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = %w(channel_200 channel_300)
    @period.since = Time.new(2020, 3, 20, 12, 0, 0, '+09:00')
    @period.until = nil

    assert(@period.valid?, '検索条件が有効')

    result = @period.result

    # 日時の昇順
    assert_equal(
      [
        @privmsg_toybox_channel_300_20200320210954,
        @notice_toybox_channel_300_20200321000000,
      ],
      result.messages.to_a
    )
  end

  test 'チャンネルと終了日時を指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = %w(channel_200 channel_300)
    @period.since = nil
    @period.until = Time.new(2020, 3, 20, 2, 36, 0, '+09:00')

    assert(@period.valid?, '検索条件が有効')

    result = @period.result

    # 会話メッセージ
    # 日時の昇順
    assert_equal(
      [
        @notice_toybox_channel_300_20200320000000,
        @join_role_channel_200_20200320023455,
        @privmsg_role_channel_200_20200320023456,
        @nick_role_channel_200_20200320023501,
      ],
      result.messages.to_a
    )
  end

  test 'チャンネル、開始日時、終了日時を指定した場合の検索結果が正しい' do
    prepare_messages

    @period.channels = %w(channel_200 channel_300)
    @period.since = Time.new(2020, 3, 20, 0, 0, 0, '+09:00')
    @period.until = Time.new(2020, 3, 20, 2, 36, 0, '+09:00')

    assert(@period.valid?, '検索条件が有効')

    result = @period.result

    # 日時の昇順
    assert_equal(
      [
        @notice_toybox_channel_300_20200320000000,
        @join_role_channel_200_20200320023455,
        @privmsg_role_channel_200_20200320023456,
        @nick_role_channel_200_20200320023501,
      ],
      result.messages.to_a
    )
  end

  test '同時刻のNICKが1つにまとめられる' do
    prepare_messages

    @period.channels = %w(channel_100 channel_200)
    @period.since = Time.new(2020, 3, 20, 2, 35, 0, '+09:00')
    @period.until = Time.new(2020, 3, 20, 2, 35, 2, '+09:00')

    assert(@period.valid?, '検索条件が有効')

    result = @period.result

    # 日時の昇順
    assert_equal(
      [
        @nick_role_channel_200_20200320023501,
      ],
      result.messages.to_a
    )
  end

  test '同時刻のQUITが1つにまとめられる' do
    prepare_messages

    @period.channels = %w(channel_100 channel_200)
    @period.since = Time.new(2020, 3, 20, 2, 40, 0, '+09:00')
    @period.until = Time.new(2020, 3, 20, 2, 40, 2, '+09:00')

    assert(@period.valid?, '検索条件が有効')

    result = @period.result

    # 日時の昇順
    assert_equal(
      [
        @quit_role_channel_200_20200320024001,
      ],
      result.messages.to_a
    )
  end

  test '該当件数が上限に達しなければnum_of_messages_limited?は偽' do
    prepare_messages

    @period.channels = %w(channel_100 channel_200 channel_300)
    @period.since = Time.new(2020, 3, 20, 0, 0, 0, '+09:00')
    @period.until = nil
    @period.limit = 5000

    assert(@period.valid?, '検索条件が有効')

    result = @period.result

    assert_equal(14, result.messages.length)
    refute(result.num_of_messages_limited?)
  end

  test '該当件数が上限に達したならばnum_of_messages_limited?は真' do
    prepare_messages

    @period.channels = %w(channel_100 channel_200 channel_300)
    @period.since = Time.new(2020, 3, 20, 0, 0, 0, '+09:00')
    @period.until = nil
    @period.limit = 10

    assert(@period.valid?, '検索条件が有効')

    result = @period.result

    assert_equal(10, result.messages.length)
    assert(result.num_of_messages_limited?)
  end
end
