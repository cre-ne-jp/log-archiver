# create_table メソッドで 'ROW_FORMAT=DYNAMIC' が
# デフォルトで指定されるようにする
# @see http://qiita.com/kamipo/items/101aaf8159cf1470d823
# Rails5 では alias_method_chain が非推奨になったため変更
# @see https://qiita.com/okamu_/items/5eb81688849fbe351350
module Utf8mb4
  def create_table(table_name, options = {})
    table_options = options.merge(options: 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC')
    super(table_name, table_options) do |td|
      yield td if block_given?
    end
  end
end

ActiveSupport.on_load :active_record do
  module ActiveRecord::ConnectionAdapters
    class AbstractMysqlAdapter
      prepend Utf8mb4
    end
  end
end
