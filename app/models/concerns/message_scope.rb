# frozen_string_literal: true

module MessageScope
  extend ActiveSupport::Concern

  included do
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
          if until_date.kind_of?(Date)
            where('timestamp < ?', until_date.next_day)
          else
            where('timestamp < ?', until_date)
          end
        else
          all
        end
      }
    )
  end
end
