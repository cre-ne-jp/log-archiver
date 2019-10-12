# frozen_string_literal: true

require 'set'

class ConversationMessage < ApplicationRecord
  include HashForJson

  belongs_to :channel
  belongs_to :irc_user

  validates :channel, presence: true
  validates :timestamp, presence: true
  validates :nick,
    presence: true,
    length: { maximum: 64 }
  validates :message, length: { maximum: 512 }

  # チャンネルで絞り込む
  scope(
    :filter_by_channels,
    ->channels { channels.empty? ? all : where(channel: channels) }
  )

  # 開始日で絞り込む
  scope(
    :filter_by_since,
    ->since { since.present? ? where('timestamp >= ?', since) : all }
  )

  # 終了日で絞り込む
  scope(
    :filter_by_until,
    lambda { |until_date|
      if until_date.present?
        where('timestamp < ?', until_date.next_day)
      else
        all
      end
    }
  )

  # ニックネームで絞り込む
  scope(
    :filter_by_nick,
    lambda { |nick|
      if nick.present?
        where('MATCH(nick) AGAINST(? IN BOOLEAN MODE)', "*D+ #{nick}")
      else
        all
      end
    }
  )

  # 全文検索
  scope(
    :full_text_search,
    lambda { |query|
      if query.present?
        where('MATCH(message) AGAINST(? IN BOOLEAN MODE)', "*D+ #{query}")
      else
        all
      end
    }
  )

  # URLのフラグメント識別子を返す
  # @return [String]
  # @todo idに依存しないフラグメント識別子を作る
  def fragment_id
    "c#{id}"
  end

  # to_hash_for_json で残すキー
  KEYS_OF_HASH_FOR_JSON = Set.new(
    %w(type timestamp nick message)
  ).freeze

  # JSON ダンプ用の Hash に変換する
  # @return [Hash]
  def to_hash_for_json
    to_hash_for_json_with_channel_and_irc_user(KEYS_OF_HASH_FOR_JSON)
  end
end
