module HashForJson
  extend ActiveSupport::Concern

  included do
    # JSON ダンプ用の Hash を返す
    # @return [Hash]
    def self.hash_for_json
      all.map(&:to_hash_for_json)
    end

    # JSON ダンプ用の Hash に対するバッチ処理
    # @param [Integer] batch_size バッチ数
    # @param [Array<Symbol>] with eager_loadする列名の配列
    # @yieldparam [Array<Hash>] 取得した Hash の配列
    def self.each_group_of_hash_for_json_in_batches(batch_size = 1000, with = [])
      all.
        includes(with).
        find_in_batches(batch_size: batch_size) do |entries|
          hashes = entries.map(&:to_hash_for_json)
          yield hashes
        end
    end
  end

  # JSON ダンプ用の Hash に変換する
  # @return [Hash]
  def to_hash_for_json
    hash = self.respond_to?(:type) ? { 'type' => self.type } : {}
    hash.merge(JSON.parse(self.to_json))
  end
end
