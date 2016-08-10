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

  test 'logging_enabled は必須' do
    @channel.logging_enabled = nil
    refute(@channel.valid?)
  end

  test 'name_with_prefix は接頭辞付きのチャンネル名を返す' do
    assert_equal('#irc_test', @channel.name_with_prefix)
  end
end
