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

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @setting.to_hash_for_json

    assert_equal(@setting.id, hash['id'])
    assert_equal(@setting.site_title, hash['site_title'])
    assert_equal(@setting.text_on_homepage, hash['text_on_homepage'])
    assert_equal(@setting.created_at, Time.parse(hash['created_at']))
    assert_equal(@setting.updated_at, Time.parse(hash['updated_at']))
  end
end
