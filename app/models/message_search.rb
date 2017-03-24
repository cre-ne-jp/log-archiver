class MessageSearch
  include ActiveModel::Model

  # キーワード
  # @return [String]
  attr_accessor :keyword
  # チャンネル識別子
  #
  # パラメータ名の都合で名前がchannelでも識別子を表すことに注意。
  # @return [String]
  attr_accessor :channel
  # 開始日
  #
  # 名称はGoogle検索に準拠している。
  # @return [Date, nil]
  attr_accessor :since
  # 終了日
  #
  # 名称はGoogle検索に準拠している。
  # @return [Date, nil]
  attr_accessor :until

  validates(:keyword, presence: true)
  validates(:channel,
            presence: true,
            inclusion: { in: Channel.pluck(:identifier) })

  validate :until_must_not_be_less_than_since_if_both_exist

  # 開始日を設定する
  #
  # Date型に変換できないときはnilになる。
  # @param [#to_date] value 開始日
  def since=(value)
    begin
      @since = value.to_date
    rescue
      @since = nil
    end
  end

  # 終了日を設定する
  #
  # Date型に変換できないときはnilになる。
  # @param [#to_date] value 終了日
  def until=(value)
    begin
      @until = value.to_date
    rescue
      @until = nil
    end
  end

  # 属性のハッシュを返す
  # @return [Hash]
  def attributes
    {
      'keyword' => @keyword,
      'channel' => @channel,
      'since' => @since,
      'until' => @until
    }
  end

  # 指定したハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [Hash] 指定したハッシュ
  def attributes=(hash)
    self.keyword = hash['keyword']
    self.channel = hash['keyword']
    self.since = hash['since']
    self.until = hash['until']

    hash
  end

  private

  # 開始日と終了日が共に指定されているときは、
  # 開始日が終了日より後になっていないことを確認する
  def until_must_not_be_less_than_since_if_both_exist
    if @since && @until
      if @since > @until
        errors.add(
          :until,
          I18n.t('errors.messages.greater_than_or_equal_to',
                 count: @since)
        )
      end
    end
  end
end
