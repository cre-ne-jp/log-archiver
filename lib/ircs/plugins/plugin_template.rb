# vim: fileencoding=utf-8

module LogArchiver
  module Plugin
    # プラグインのひな形
    class Template
      include Cinch::Plugin

      # データベース接続インスタンスをクラス変数に格納する
      def initialize(*args)
        super

        @logger = config[:logger]
      end
    end
  end
end
