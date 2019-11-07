# frozen_string_literal: true

class ArchivedConversationMessage < ApplicationRecord
  include MessageDigest

  self.inheritance_column = :_type_disabled

  before_save :refresh_digest!

  belongs_to :channel
  belongs_to :irc_user
  belongs_to :archive_reason

  validates :old_id, presence: true
  validates :channel, presence: true
  validates :timestamp, presence: true
  validates :nick,
    presence: true,
    length: { maximum: 64 }
  validates :message, length: { maximum: 512 }
  validates :type, inclusion: { in: %w(Privmsg Notice) }
  validates :archive_reason, presence: true

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
    "a#{digest_value}"
  end

  # ConversationMessage インスタンスから値をコピーする
  # @param [ConversationMessage] m
  # @return [Hash]
  def self.from_conversation_message(m)
    new(old_id: m.id).from_conversation_message
  end

  def from_conversation_message
    m = ConversationMessage.find(old_id)
    assign_attributes(
      channel_id: m.channel_id,
      timestamp: m.timestamp,
      nick: m.nick,
      message: m.message,
      type: m.type,
      irc_user_id: m.irc_user_id,
      digest: m.digest,
      created_at: m.created_at
    )

    self
  end
end
