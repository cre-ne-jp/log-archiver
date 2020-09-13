# frozen_string_literal: true

class RefreshDigestsJob < ApplicationJob
  queue_as :default

  # ジョブ本体
  # @param [Hash] args
  # @option args [String] :model 再計算するモデルの名前
  # @option args [String/Integer] :target_id モデルが指定されているときのみ、対象の id
  # @return [void]
  def perform(**args)
    case args[:model]
    when *%w(ConversationMessage Message Join Kick Nick Notice Part Privmsg Quit Topic)
      model = Module.const_get(args[:model])

      if(args[:target_id].present?)
        m = model.find(args[:target_id])
        m.refresh_digest!
        m.save!
      else
        refresh_digests(model)
      end
    else
      [ConversationMessage, Message].each do |m|
        refresh_digests(m)
      end
    end
  end

  private

  # ハッシュ値を更新する
  # @param [Class] model 対象モデル
  # @param [Integer] batch_size 一度に処理する件数
  # @return [void]
  def refresh_digests(model, batch_size = 10000)
    handler = LogArchiver::RefreshDigests.new(:job)
    handler.refresh_digests(model, batch_size)
  end
end
