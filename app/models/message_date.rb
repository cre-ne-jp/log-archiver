class MessageDate < ApplicationRecord
  belongs_to :channel
  validates :channel, presence: true
  validates :date, presence: true

  # 指定したチャンネルのメッセージが存在する年の配列を返す
  # @param [Channel] channel チャンネル
  # @return [Array<Integer>]
  def self.years(channel)
    where(channel: channel).
      distinct.
      order(:date).
      pluck('date').
      map do |date|
        date.year
      end.
      uniq
  end

  # 指定したチャンネルのメッセージが存在する年月の配列を返す
  # @param [Channel] channel チャンネル
  # @return [Array<Array<Integer, Integer>>]
  def self.year_month_list(channel)
    where(channel: channel).
      distinct.
      order(:date).
      pluck('date').
      map do |date|
        [date.year, date.month]
      end.
      uniq
  end
end
