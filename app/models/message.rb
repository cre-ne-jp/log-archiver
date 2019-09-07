# frozen_string_literal: true

require 'set'

class Message < ApplicationRecord
  include HashForJson

  belongs_to :channel
  belongs_to :irc_user

  validates :channel, presence: true
  validates :timestamp, presence: true
  validates :nick,
    presence: true,
    length: { maximum: 64 }
  validates :message, length: { maximum: 512 }

  # URLのフラグメント識別子を返す
  # @return [String]
  # @todo idに依存しないフラグメント識別子を作る
  def fragment_id
    "m#{id}"
  end

  # to_hash_for_json で残すキーの集合
  KEYS_OF_HASH_FOR_JSON = Set.new(
    %w(type timestamp nick message target)
  ).freeze

  # JSON ダンプ用の Hash に変換する
  # @return [Hash]
  def to_hash_for_json
    to_hash_for_json_with_channel_and_irc_user(KEYS_OF_HASH_FOR_JSON)
  end
end
