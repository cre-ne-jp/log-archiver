# frozen_string_literal: true

require 'sidekiq/worker'
include Sidekiq::Worker

module LogArchiver
  class RefreshDigests
    # ログ出力
    attr_writer :logger

    # ロガーを設定する
    # @param [Hash] logging
    # @option logging :job Sidekiq のデフォルトロガーを使う
    # @option logging :stdout 標準出力にログを書き出す
    # @return [void]
    def initialize(logging = nil)
      @logger = case(logging)
        when :job
          Sidekiq.logger
        when :stdout
          Logger.new(STDOUT)
        else
          Rails.logger
        end
    end

    # ハッシュ値を更新する
    # @param [Class] model 対象モデル
    # @param [Integer] batch_size 一度に処理する件数
    # @return [void]
    def refresh_digests(model, batch_size = 10000)
      log_header = "[RefreshDigests(#{model.name})]: "

      @logger.info("#{log_header}start.")

      if batch_size < 1
        raise ArgumentError, 'batch_size には1以上を設定してください'
      end

      n = 0
      model.find_in_batches(batch_size: batch_size) do |data|
        data.each(&:refresh_digest!)
        model.import(data, on_duplicate_key_update: [:digest])

        n += data.length
        @logger.info("#{log_header}Updated #{n} records.")
      end

      @logger.info("#{log_header}completed.")
    end
  end
end
