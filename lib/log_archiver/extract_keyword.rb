# frozen_string_literal: true

module LogArchiver
  # 発言からキーワードを抜き出し、登録するクラス
  class ExtractKeyword
    # @param [Privmsg] privmsg メッセージ
    # @param [String/Regexp] command キーワード登録コマンド接頭辞
    # @param [Boolean] :quiet 処理状況を出力するなら false
    # @return [Hash]
    def self.run(privmsg, command = /\A\.(k|a)[ 　]+/, quiet: true)
      display_title = privmsg.message.sub(command, '').strip
      title = Keyword.normalize(display_title)

      result = {keyword: false, privmsg: false}

      Keyword.transaction do
        keyword = Keyword.find_or_initialize_by(title: title)

        if keyword.new_record?
          keyword.display_title = display_title

          begin
            keyword.save!

            result[:keyword] = true
            puts("#{title} => #{display_title}") unless quiet
          rescue => e
            puts("! #{title}: #{e}") unless quiet
            raise ActiveRecord::Rollback
          end
        end

        unless privmsg.keyword == keyword
          begin
            privmsg.keyword = keyword
            privmsg.save!

            result[:privmsg] = true
            puts("PRIVMSG #{privmsg.id} <-> #{keyword.title}") unless quiet
          rescue => e
            puts("! PRIVMSG #{privmsg.id} <-> #{keyword.title}: #{e}") unless quiet
            raise ActiveRecord::Rollback
          end
        end
      end

      result
    end
  end
end
