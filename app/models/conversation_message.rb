# frozen_string_literal: true

class ConversationMessage < ApplicationRecord
  include MessageDigest

  before_save :refresh_digest!

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
  def fragment_id
    refresh_digest_unless_exist!

    "c#{digest_value}"
  end
end
