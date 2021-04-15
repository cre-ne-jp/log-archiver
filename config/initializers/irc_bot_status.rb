irc_bot_status_config = OpenStruct.new
irc_bot_status_config.socket_path = "#{Rails.root}/tmp/sockets/ircbot.sock"
Rails.application.config.irc_bot_status = irc_bot_status_config
