require 'test_helper'

require 'ircs/irc_bot_version'

class IrcBotVersionTest < ActiveSupport::TestCase
  test '正しい形式でアプリケーション名、バージョン、コミットIDが得られる' do
    assert_match(/\AIRC Log Archiver \(IRC bot\) \d+\.\d+\.\d+ \(\w+\)\z/,
                 LogArchiver::Ircs::APP_NAME_VERSION_COMMIT_ID)
  end
end
