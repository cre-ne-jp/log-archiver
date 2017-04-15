require 'test_helper'

class HourSeparatorTest < ActiveSupport::TestCase
  setup do
    @date1 = Date.new(2017, 4, 1)
    @separator1 = HourSeparator.new(@date1, 9)

    @date2 = Date.new(2016, 12, 24)
    @separator2 = HourSeparator.new(@date2, 15)
  end

  test 'インスタンスを作ることができる' do
    assert(@separator1)
    assert(@separator2)
  end

  test '無効な時刻を指定するとインスタンスを作成できない' do
    assert_raises('-1時') { HourSeparator.new(@date1, -1) }
    assert_raises('24時') { HourSeparator.new(@date1, 24) }
    assert_raises('12.3時') { HourSeparator.new(@date1, 12.3) }
  end

  test 'timestamp が正しい' do
    assert_equal(Time.zone.local(2017, 4, 1, 9, 0, 0),
                 @separator1.timestamp)
    assert_equal(Time.zone.local(2016, 12, 24, 15, 0, 0),
                 @separator2.timestamp)
  end

  test 'fragment_id が正しい' do
    assert_equal('090000', @separator1.fragment_id, '9時')
    assert_equal('150000', @separator2.fragment_id, '15時')
  end

  test 'for_day_browse が正しい' do
    expected = lambda { |date, max_hour|
      (0..max_hour).map { |hour|
        Time.zone.local(date.year, date.month, date.day, hour, 0, 0)
      }
    }

    result =
      ->(date) { HourSeparator.for_day_browse(date).map(&:timestamp) }

    travel_to(Time.zone.local(2017, 4, 1, 3, 34, 56)) do
      assert_equal(expected[@date2, 23],
                   result[@date2],
                   '過去の日は 0〜23 時分が返る')

      assert_equal(expected[@date1, 3],
                   result[@date1],
                   '現在時刻より前のものだけ返る')
    end
  end
end
