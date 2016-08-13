%w(irc_test irc_test2).each do |channel_name|
  Channel.find_or_create_by(name: channel_name) do |channel|
    channel.identifier = channel_name
    channel.logging_enabled = true
  end
end
