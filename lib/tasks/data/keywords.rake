namespace :data do
  namespace :keywords do
    desc '登録されているキーワードをすべて削除する'
    task :delete_all do
      Keyword.delete_all
    end

    desc '登録されているPRIVMSGからキーワードを抽出して登録する'
    task :extract_from_privmsgs do
      privmsgs = Privmsg.
        where("message LIKE '.k %'").
        order(:timestamp).
        pluck(:id, :channel_id, :timestamp, :message)

      privmsgs.each do |privmsg|
        display_title = privmsg[3].sub(/\A\.k /, '').strip
        title = Keyword.normalize(display_title)

        keyword = Keyword.find_or_initialize_by(title: title)
        if keyword.new_record?
          keyword.display_title = display_title

          begin
            keyword.save!
            puts("#{title} => #{display_title}")
          rescue => e
            puts("! #{title}: #{e}")
          end
        end
      end
    end
  end
end
