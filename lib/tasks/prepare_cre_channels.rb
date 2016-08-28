module Tasks
  module PrepareCreChannels
    CHANNELS = [
      ['next', 'NEXT'],
      ['cre', 'cre'],
      ['opentrpg', 'openTRPG'],
      ['cat', '猫'],
      ['picture', '写真'],
      ['computer', 'ぱそ'],
      ['baseball', '野球'],
      ['cooking', '料理'],
      ['mono', 'モノ作り'],
      ['millitary', '軍事技術'],
      ['sci-tech', '科学技術'],
      ['sound', '音づくり'],
      ['write', 'もの書き'],
      ['write-ex1', 'もの書き予備'],
      ['write-ex2', 'もの書き外典'],
      ['football', 'フットボール'],
      ['boardgame', 'ボードゲーム'],
      ['kataribe', 'kataribe'],
      ['ka-01', 'KA-01'],
      ['ka-02', 'KA-02'],
      ['ka-03', 'KA-03'],
      ['ka-04', 'KA-04'],
      ['ka-05', 'KA-05'],
      ['ka-06', 'KA-06'],
      ['ha06', 'HA06'],
      ['ha06-01', 'HA06-01'],
      ['ha06-02', 'HA06-02'],
      ['ha21', 'HA21']
    ]

    module_function
    def self.execute
      CHANNELS.each do |identifier, name|
        begin
          Channel.find_or_create_by!(identifier: identifier) do |channel|
            channel.name = name
            channel.logging_enabled = false
          end
        rescue => e
          puts("#{name}: #{e}")
        end
      end
    end
  end
end
