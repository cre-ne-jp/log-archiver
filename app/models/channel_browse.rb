# 指定した日付の閲覧のモデル
class ChannelBrowse
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  extend SimpleEnum::Attribute

  # チャンネル識別子
  #
  # パラメータ名の都合で名前がchannelでも識別子を表すことに注意。
  # @return [String]
  attr_accessor :channel
  # 日付指定の種類のコード
  attr_accessor :date_type_cd
  # 日付指定の種類
  #
  # * today: 今日
  # * yesterday: 昨日
  # * specify: 日付指定
  as_enum(:date_type, %i{today yesterday specify}, prefix: :is_date_type)
  # 日付
  # @return [Date, nil]
  #
  # date_type が :specify のときは必須。
  #
  # セッターでは、Date型に変換できないときはnilになる。
  attr_reader :date

  validates(:channel,
            presence: true)
  validates(:date_type, presence: true)
  validates(:date,
            if: :is_date_type_specify?,
            presence: true)

  def initialize(*)
    self.date_type = :today
    super
  end

  # 日付を設定する
  #
  # Date型に変換できないときはnilになる。
  # @param [#to_date] value 開始日
  def date=(value)
    begin
      @date = value.to_date
    rescue
      @date = nil
    end
  end

  # 属性のハッシュを返す
  # @return [Hash]
  def attributes
    {
      'channel' => @channel,
      'date_type' => date_type,
      'date' => @date
    }
  end

  # 指定したハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [void]
  def attributes=(hash)
    self.channel = hash['channel']
    self.date_type = hash['date_type']
    self.date = hash['date']
  end

  # ChannelBrowse::Day オブジェクトに変換する
  # @return [ChannelBrowse::Day] 変換結果
  # @return [nil] 属性が正しくなかった場合
  def to_channel_browse_day
    return nil unless valid?

    channel = Channel.friendly.find(@channel)

    case date_type
    when :today
      ChannelBrowse::Day.today(channel)
    when :yesterday
      ChannelBrowse::Day.yesterday(channel)
    when :specify
      ChannelBrowse::Day.new(channel: channel, date: @date)
    end
  end
end
