# frozen_string_literal: true

class RefreshDigestsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    case args[:model]
    when ConversationMessage, Message
      if(args[:target_id].numeric?)
        m = args[:model].find(args[:target_id])
        m.refresh_digest!
        m.save!
      else
        refresh_digests(args[:model])
      end
    else
      [ConversationMessage, Message].each do |model|
        refresh_digests(model)
      end
    end
  end

  private

  # ハッシュ値を更新する
  # @param [Class] model 対象モデル
  # @param [Integer] batch_size 一度に処理する件数
  # @return [void]
  def refresh_digests(model, batch_size = 10000)
    log_header = "[RefreshDigests(#{model})]: "

    puts("#{log_header}start.")

    if batch_size < 1
      raise ArgumentError, 'batch_size には1以上を設定してください'
    end

    n = 0
    model.find_in_batches(batch_size: batch_size) do |data|
      data.each(&:refresh_digest!)
      model.import(data, on_duplicate_key_update: [:digest])

      n += data.length
      puts("#{log_header}Updated #{n} records.")
    end

    puts("#{log_header}completed.")
  end
end
