class MessageDate < ActiveRecord::Base
  belongs_to :channel
  validates :channel, presence: true
  validates :date, presence: true

  # 指定したチャンネルのメッセージが存在する年月の配列を返す
  # @param [Channel] channel チャンネル
  # @return [Array<Array<Integer, Integer>>]
  def self.year_month_list(channel)
    where(channel: channel).
      uniq.
      order(:date).
      pluck('YEAR(date), MONTH(date)')
  end
end
