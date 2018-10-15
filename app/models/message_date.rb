# frozen_string_literal: true

# メッセージが存在する日付のモデル
class MessageDate < ApplicationRecord
  belongs_to :channel
  validates :channel, presence: true
  validates :date, presence: true

  # 指定したチャンネルのメッセージが存在する年の配列を返す
  # @param [Channel] channel チャンネル
  # @return [Array<Integer>]
  def self.years(channel)
    where(channel: channel).
      group(:year).
      order(Arel.sql('EXTRACT(YEAR FROM date)')).
      pluck(Arel.sql('EXTRACT(YEAR FROM date) AS year'))
  end

  # 指定したチャンネルのメッセージが存在する年月の配列を返す
  # @param [Channel] channel チャンネル
  # @return [Array<Array<Integer, Integer>>]
  def self.year_month_list(channel)
    where(channel: channel).
      group(:year, :month).
      order(Arel.sql('EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)')).
      pluck(Arel.sql('EXTRACT(YEAR FROM date) AS year, ' \
                     'EXTRACT(MONTH FROM date) AS month'))
  end
end
