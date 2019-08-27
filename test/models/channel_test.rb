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

  test 'name の形式が合っていないものは無効' do
    @channel.name = '#もの書き'
    refute(@channel.valid?, '先頭に "#" があるものは無効')

    @channel.name = 'もの 書き'
    refute(@channel.valid?, '空白があるものは無効')

    @channel.name = 'もの,書き'
    refute(@channel.valid?, '"," があるものは無効')

    @channel.name = 'もの:書き'
    refute(@channel.valid?, '":" があるものは無効')
  end

  test 'identifier は必須' do
    @channel.identifier = ''
    refute(@channel.valid?)
  end

  test 'identifier は空白のみではならない' do
    @channel.identifier = ' ' * 10
    refute(@channel.valid?)
  end

  test 'identifier の形式が合っていないものは無効' do
    @channel.identifier = 'もの書き'
    refute(@channel.valid?, '許可されていない文字があるものは無効')

    @channel.identifier = '-write'
    refute(@channel.valid?, '先頭にハイフンがあるものは無効')

    @channel.identifier = '_write'
    refute(@channel.valid?, '先頭にアンダーラインがあるものは無効')

    @channel.identifier = '0write'
    refute(@channel.valid?, '先頭に数字があるものは無効')
  end

  test 'identifier: 西生駒' do
    @channel.identifier = 'nishiikoma'
    assert(@channel.valid?)
  end

  test 'identifier: openTRPG' do
    @channel.identifier = 'openTRPG'
    assert(@channel.valid?)
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

  test 'for_channels_index の順序が正しい' do
    Channel.delete_all

    [100, 200, 300, 400, 500].each do |id|
      create("channel_#{id}".to_sym)
    end

    [100, 200, 400].each do |id|
      create("channel_#{id}_last_speech".to_sym)
    end

    expected = [100, 400, 200, 300, 500].map { |id| "channel_#{id}" }
    assert_equal(expected, Channel.for_channels_index.map(&:identifier))
  end

  test 'from_cinch_message: 該当するチャンネルが返る' do
    cinch_channel = Minitest::Mock.new.expect(:name, '#irc_test')
    cinch_message = Minitest::Mock.new.expect(:channel, cinch_channel)

    assert_equal(@channel, Channel.from_cinch_message(cinch_message))
  end

  test 'from_cinch_message: 登録されていないチャンネル名が指定された場合 nil が返る' do
    cinch_channel = Minitest::Mock.new.expect(:name, '#not_registered')
    cinch_message = Minitest::Mock.new.expect(:channel, cinch_channel)

    assert_nil(Channel.from_cinch_message(cinch_message))
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @channel.to_hash_for_json

    assert_equal(@channel.id, hash['id'])
    assert_equal(@channel.name, hash['name'])
    assert_equal(@channel.identifier, hash['identifier'])
    assert_equal(@channel.logging_enabled, hash['logging_enabled'])
    assert_equal(@channel.created_at, Time.parse(hash['created_at']))
    assert_equal(@channel.updated_at, Time.parse(hash['updated_at']))
    assert_equal(@channel.row_order, hash['row_order'])
    assert_equal(@channel.canonical_url_template, hash['canonical_url_template'])
  end
end
