require 'test_helper'

class AdminHelperTest < ActiveSupport::TestCase
  include AdminHelper

  test '1秒' do
    assert_equal('00:00:01', format_uptime(1))
  end

  test '1分23秒' do
    assert_equal('00:01:23', format_uptime(1 * 60 + 23))
  end

  test '1時間23分45秒' do
    assert_equal('01:23:45',
                 format_uptime((1 * 60 * 60) + (23 * 60) + 45))
  end

  test '1日2時間3分4秒' do
    assert_equal('1日 02:03:04',
                 format_uptime((1 * 24 * 60 * 60) +
                               (2 * 60 * 60) + (3 * 60) + 4))
  end

  test '12日23時間34分56秒' do
    assert_equal('12日 23:34:56',
                 format_uptime((12 * 24 * 60 * 60) +
                               (23 * 60 * 60) + (34 * 60) + 56))
  end
end
