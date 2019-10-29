# frozen_string_literal: true

module LogArchiver
  # 発言からキーワードを抜き出し、登録する処理のクラス
  class ExtractKeyword
    # 既定のキーワード登録コマンドの接頭辞
    # @type [Regexp]
    DEFAULT_COMMAND_PREFIX = /\A\.(k|a)[ 　]+/.freeze

    # @return [String, Regexp] キーワード登録コマンドの接頭辞
    attr_reader :command_prefix
    # @return [Boolean] 処理状況を冗長に出力するか
    attr_reader :verbose

    # キーワード抽出、登録処理を初期化する
    # @param [String, Regexp] command_prefix キーワード登録コマンドの接頭辞
    # @param [Boolean] verbose 処理状況を冗長に出力するか
    def initialize(command_prefix: DEFAULT_COMMAND_PREFIX, verbose: false)
      # キーワード登録コマンドの接頭辞
      # @type [String, Regexp]
      @command_prefix = command_prefix
      # 処理状況を冗長に出力するか
      # @type [Boolean]
      @verbose = verbose
    end

    # キーワード抽出、登録処理を実行する
    # @param [Privmsg] privmsg メッセージ
    # @return [Hash] キーワードおよびPRIVMSGの保存に成功したか
    def run(privmsg)
      display_title = privmsg.message.sub(@command_prefix, '').strip
      title = Keyword.normalize(display_title)

      # 処理の結果
      result = { keyword: false, privmsg: false }

      Keyword.transaction do
        keyword = Keyword.find_or_initialize_by(title: title) do |k|
          k.display_title = display_title
        end

        if keyword.new_record?
          result[:keyword] = save_keyword(keyword)
          raise ActiveRecord::Rollback unless result[:keyword]
        end

        unless privmsg.keyword == keyword
          result[:privmsg] = associate_privmsg_with_keyword(
            privmsg, keyword
          )
          raise ActiveRecord::Rollback unless result[:privmsg]
        end
      end

      result
    end

    private

    # キーワードを保存する
    # @param [Keyword] keyword 保存対象のキーワード
    # @return [Boolean] 保存に成功したか
    def save_keyword(keyword)
      keyword.save!
      try_log("#{keyword.title} => #{keyword.display_title}")

      return true
    rescue => e
      try_log("! #{keyword.title}: #{e}")
      return false
    end

    # PRIVMSGとキーワードを関連づける
    # @param [Privmsg] privmsg 対象のPRIVMSG
    # @param [Keyword] keyword 対象のキーワード
    # @param [Boolean] :quiet 処理状況を出力するなら false
    # @return [Boolean] 保存に成功したか
    def associate_privmsg_with_keyword(privmsg, keyword)
      privmsg.keyword = keyword
      privmsg.save!

      try_log("PRIVMSG #{privmsg.id} <-> #{keyword.title}")

      return true
    rescue => e
      try_log("! PRIVMSG #{privmsg.id} <-> #{keyword.title}: #{e}")
      return false
    end

    # ログ出力を試みる
    # @param [String] message 出力するメッセージ
    # @return [void]
    #
    # verboseがtrueに指定されていた場合のみログを出力する
    def try_log(message)
      puts(message) if @verbose
    end
  end
end
