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
end
