require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  setup do
    @setting = create(:setting)
  end

  test '有効である' do
    assert(@setting.valid?)
  end

  test 'site_title は必須' do
    @setting.site_title = ''
    refute(@setting.valid?)
  end

  test 'site_title は空白のみではならない' do
    @setting.site_title = ' ' * 10
    refute(@setting.valid?)
  end

  test 'site_title は 255 文字以下' do
    @setting.site_title = 'A' * 256
    refute(@setting.valid?)
  end
end
