# create_table メソッドで 'ROW_FORMAT=DYNAMIC' が
# デフォルトで指定されるようにする
# @see http://qiita.com/kamipo/items/101aaf8159cf1470d823
ActiveSupport.on_load :active_record do
  module ActiveRecord::ConnectionAdapters
    class AbstractMysqlAdapter
      ROW_FORMAT_DYNAMIC = 'ROW_FORMAT=DYNAMIC'.freeze

      def create_table_with_innodb_row_format(table_name, options = {})
        old_options = options[:options]
        new_options =
          if old_options
            "#{old_options} #{ROW_FORMAT_DYNAMIC}"
          else
            ROW_FORMAT_DYNAMIC
          end

        table_options = options.merge(options: new_options)
        create_table_without_innodb_row_format(table_name, table_options) do |td|
          yield td if block_given?
        end
      end
      alias_method_chain :create_table, :innodb_row_format
    end
  end
end
