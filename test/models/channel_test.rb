require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  setup do
    @channel = create(:channel)
  end

  test 'name は必須' do
    @channel.name = ''
    refute(@channel.valid?)
  end

  test 'name は空白のみではならない' do
    @channel.name = ' ' * 10
    refute(@channel.valid?)
  end

  test 'identifier は必須' do
    @channel.identifier = ''
    refute(@channel.valid?)
  end

  test 'identifier は空白のみではならない' do
    @channel.identifier = ' ' * 10
    refute(@channel.valid?)
  end

  test 'identifier はユニーク' do
    channel2 = Channel.new(
      name: '#irc_test2',
      identifier: @channel.identifier,
      logging_enabled: true
    )
    refute(channel2.valid?)
  end

  test 'name_with_prefix は接頭辞付きのチャンネル名を返す' do
    assert_equal('#irc_test', @channel.name_with_prefix)
  end

  test 'lowercase_name_with_prefix は小文字の接頭辞付きチャンネル名を返す' do
    channel = create(:channel_with_camel_case_name)
    assert_equal('#camelcasechannel', channel.lowercase_name_with_prefix)
  end
end
