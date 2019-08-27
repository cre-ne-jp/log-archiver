module HashForJson
  extend ActiveSupport::Concern

  included do
    # JSON ダンプ用の Hash を返す
    # @return [Hash]
    def self.hash_for_json
      all.map { |c|
        JSON.parse(c.to_json)
      }
    end
  end
end
