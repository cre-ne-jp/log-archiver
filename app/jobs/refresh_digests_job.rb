# frozen_string_literal: true

class RefreshDigestsJob < ApplicationJob
  queue_as :default

  # ジョブ本体
  # @return [void]
  def perform
    [ConversationMessage, Message].each do |m|
      refresh_digests(m)
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
