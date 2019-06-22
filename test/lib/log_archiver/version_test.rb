require 'test_helper'

module LogArchiver
  class VersionTest < ActiveSupport::TestCase
    test 'バージョンが正しい形式で設定されている' do
      assert_match(/\A\d+\.\d+\.\d+\z/, LogArchiver::VERSION)
    end
  end
end
