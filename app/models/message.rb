# frozen_string_literal: true

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
  def fragment_id
    "m#{id}"
  end

  # to_hash_for_json で残すキー
  KEYS_OF_HASH_FOR_JSON =
    %w(type timestamp nick message target channel user host).freeze

  # JSON ダンプ用の Hash に変換する
  # @return [Hash]
  def to_hash_for_json
    super.
      select { |key, _| KEYS_OF_HASH_FOR_JSON.include?(key) }.
      merge({
        'channel' => channel.name,
        'user' => irc_user.user,
        'host' => irc_user.host
      })
  end
end
