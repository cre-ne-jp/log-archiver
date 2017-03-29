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

      # IRC へ発言し、データベースに保存する
      # このメソッドを経由しないと、自分自身の発言が保存できない
      # @param [Cinch::Message] m
      # @param [String] message 送信するメッセージ
      def send(m, message)
        m.target.send(message, true)
      end
    end
  end
end
