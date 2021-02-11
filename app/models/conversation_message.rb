# frozen_string_literal: true

class ConversationMessage < ApplicationRecord
  include MessageDigest
  include MessageScope

  before_save :refresh_digest!

  belongs_to :channel
  belongs_to :irc_user

  validates :channel, presence: true
  validates :timestamp, presence: true
  validates :nick,
    presence: true,
    length: { maximum: 64 }
  validates :message, length: { maximum: 512 }

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
    "c#{digest_value}"
  end

  # @return [Boolean] 参加中の全チャンネルに同時に送られるメッセージか？
  def broadcast?
    false
  end
end
