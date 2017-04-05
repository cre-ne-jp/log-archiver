class Channel < ActiveRecord::Base
  extend FriendlyId
  friendly_id :identifier

  # 発言以外のメッセージ
  has_many :messages
  # 発言のメッセージ
  has_many :conversation_messages

  has_many :joins
  has_many :parts
  has_many :quits
  has_many :kicks
  has_many :nicks
  has_many :topics
  has_many :privmsgs
  has_many :notices

  # 発言のある日
  has_many :message_dates

  # チャンネルと最終発言の関係
  has_one :channel_last_speech
  # 最終発言
  has_one :last_speech, through: :channel_last_speech, source: :conversation_message

  validates(
    :name,
    presence: true,
    uniqueness: true,
    format: { with: /\A[^# ,:]+[^ ,:]*\z/ }
  )
  validates(
    :identifier,
    presence: true,
    uniqueness: true,
    format: { with: /\A[a-z][-_a-z0-9]*\z/ }
  )

  # ログ記録が有効なチャンネル
  scope :logging_enabled, -> { where(logging_enabled: true) }
  # ログ記録が無効なチャンネル
  scope :logging_disabled, -> { where(logging_enabled: false) }

  # ログ記録が有効なチャンネル名の配列を返す
  # @param [Boolean] lowercase 小文字に変換するかどうか
  # @return [Array<String>]
  def self.logging_enabled_names_with_prefix(lowercase: false)
    names = logging_enabled.pluck(:name)
    modifier =
      if lowercase
        ->(channel_name) { "##{channel_name.downcase}" }
      else
        ->(channel_name) { "##{channel_name}" }
      end

    names.map(&modifier)
  end

  # チャンネル名と識別子のペアの配列を返す
  # @return [Array<Array<String, String>>]
  def self.name_identifier_pairs
    select(:name, :identifier).
      map { |channel| [channel.name_with_prefix, channel.identifier] }
  end

  # チャンネル一覧用の順序のチャンネル配列を返す
  # @return [Array<Channel>]
  def self.for_channels_index
    all.
      includes(:last_speech).
      sort { |a, b|
        a_timestamp = last_speech_timestamp(a)
        b_timestamp = last_speech_timestamp(b)

        if a_timestamp == b_timestamp
          a.id <=> b.id
        else
          b_timestamp <=> a_timestamp
        end
      }
  end

  # 接頭辞付きのチャンネル名を返す
  # @return [String]
  def name_with_prefix
    "##{name}"
  end

  # 小文字の接頭辞付きチャンネル名を返す
  # @return [String]
  def lowercase_name_with_prefix
    name_with_prefix.downcase
  end

  # 現在の（キャッシュされていない）最終発言を求める
  # @return [ConversationMessage]
  def current_last_speech
    conversation_messages.
      order(timestamp: :desc).
      limit(1).
      first
  end

  private

  def self.last_speech_timestamp(channel)
    channel.last_speech&.timestamp || DateTime.new
  end
end
