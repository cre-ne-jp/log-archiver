irc_bot_status_config = OpenStruct.new
irc_bot_status_config.socket_path = "#{Rails.root}/tmp/sockets/irc-bot.sock"
Rails.application.config.irc_bot_status = irc_bot_status_config
