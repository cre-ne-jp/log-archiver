# create_table メソッドで 'ROW_FORMAT=DYNAMIC' が
# デフォルトで指定されるようにする
# @see http://qiita.com/kamipo/items/101aaf8159cf1470d823
#
# Rails5 では alias_method_chain が非推奨になったため変更
# @see https://qiita.com/horipori/items/3b1965abcd0d61f1108c
ActiveSupport.on_load :active_record do
  module ActiveRecord::ConnectionAdapters
    module CreateTableWithInnodbRowFormat
      ROW_FORMAT_DYNAMIC = 'ROW_FORMAT=DYNAMIC'.freeze

      def create_table(table_name, options = {})
        old_options = options[:options]
        new_options =
          if old_options
            "#{old_options} #{ROW_FORMAT_DYNAMIC}"
          else
            ROW_FORMAT_DYNAMIC
          end
        table_options = options.merge(options: new_options)

        super(table_name, table_options) do |td|
          yield td if block_given?
        end
      end
    end

    class AbstractMysqlAdapter
      prepend CreateTableWithInnodbRowFormat
    end
  end
end
