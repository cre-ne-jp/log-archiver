require 'rails/test_help'

require 'set'

# to_hash_for_json のテスト用のヘルパー
module TestHelperForToHashForJson
  MESSAGE_EXPECTED_KEYS = Set.new(
    %w(type timestamp nick message target channel user host)
  ).freeze

  # Messageから変換されたHashが正しいデータを含むことを表明する
  # @param [Message] message 変換元のメッセージ
  # @param [Hash] hash 変換後のHash
  # @param [String] expected_type 期待されるメッセージの種類
  # @return [void]
  def assert_contain_valid_message_data(message, hash, expected_type)
    assert_equal(MESSAGE_EXPECTED_KEYS, Set.new(hash.keys))

    assert_equal(expected_type, hash['type'])
    assert_equal(message.timestamp, Time.parse(hash['timestamp']))
    assert_equal(message.nick, hash['nick'])
    assert_equal(message.message, hash['message'])
    assert_equal(message.target, hash['target'])
    assert_equal(message.channel.name, hash['channel'])
    assert_equal(message.irc_user.user, hash['user'])
    assert_equal(message.irc_user.host, hash['host'])
  end

  CONVERSATION_MESSAGE_EXPECTED_KEYS = Set.new(
    %w(type timestamp nick message channel user host)
  ).freeze

  # ConversationMessageから変換されたHashが正しいデータを含むことを表明する
  # @param [ConversationMessage] message 変換元のメッセージ
  # @param [Hash] hash 変換後のHash
  # @param [String] expected_type 期待されるメッセージの種類
  # @return [void]
  def assert_contain_valid_conversation_message_data(message, hash, expected_type)
    assert_equal(CONVERSATION_MESSAGE_EXPECTED_KEYS, Set.new(hash.keys))

    assert_equal(expected_type, hash['type'])
    assert_equal(message.timestamp, Time.parse(hash['timestamp']))
    assert_equal(message.nick, hash['nick'])
    assert_equal(message.message, hash['message'])
    assert_equal(message.channel.name, hash['channel'])
    assert_equal(message.irc_user.user, hash['user'])
    assert_equal(message.irc_user.host, hash['host'])
  end
end
