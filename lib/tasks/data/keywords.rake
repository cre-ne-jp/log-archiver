namespace :data do
  namespace :keywords do
    desc '登録されているキーワードをすべて削除する'
    task :delete_all => :environment do
      n_relationships = PrivmsgKeywordRelationship.delete_all
      puts("#{n_relationships} 個のPRIVMSG-キーワード関連を削除しました")

      n_keywords = Keyword.delete_all
      puts("#{n_keywords} 個のキーワードを削除しました")
    end

    desc '登録されているPRIVMSGからキーワードを抽出して登録する'
    task :extract_from_privmsgs => :environment do
      privmsgs = Privmsg.
        where("message LIKE '.k %'").
        order(:timestamp)

      n_keywords = 0
      n_privmsgs = 0
      privmsgs.find_each do |privmsg|
        display_title = privmsg.message.sub(/\A\.k /, '').strip
        title = Keyword.normalize(display_title)

        keyword = Keyword.find_or_initialize_by(title: title)
        if keyword.new_record?
          keyword.display_title = display_title

          begin
            keyword.save!

            n_keywords += 1
            puts("#{title} => #{display_title}")
          rescue => e
            puts("! #{title}: #{e}")
            next
          end
        end

        unless privmsg.keyword == keyword
          begin
            privmsg.keyword = keyword
            privmsg.save!

            n_privmsgs += 1
            puts("PRIVMSG #{privmsg.id} <-> #{keyword.title}")
          rescue => e
            puts("! PRIVMSG #{privmsg.id} <-> #{keyword.title}: #{e}")
            next
          end
        end
      end

      puts
      puts("#{n_keywords} 個のキーワードを作成しました")
      puts("#{n_privmsgs} 個のPRIVMSGとキーワードを関連付けました")
    end
  end
end
