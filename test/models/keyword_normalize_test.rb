require 'test_helper'

class KeywordNormalizeTest < ActiveSupport::TestCase
  test '半角化：英字と記号' do
    assert_equal('go!プリンセスプリキュア',
                 Keyword.normalize('ｇｏ！プリンセスプリキュア'))
  end

  test '半角化：数字' do
    assert_equal('仮面ライダー1号',
                 Keyword.normalize('仮面ライダー１号'))
  end

  test '半角カタカナを全角にする' do
    assert_equal('アメコミ',
                 Keyword.normalize('ｱﾒｺﾐ'))
  end

  test '英字を小文字にする' do
    assert_equal('the_blacklist',
                 Keyword.normalize('The_Blacklist'))
  end

  test '半角スペースをアンダーバーにする' do
    assert_equal('the_blacklist',
                 Keyword.normalize('the blacklist'))
  end

  test '全角スペースをアンダーバーにする' do
    assert_equal('the_blacklist',
                 Keyword.normalize('the　blacklist'))
  end

  test '連続するアンダーバーを1つにする' do
    assert_equal('the_blacklist',
                 Keyword.normalize('the___blacklist'))
  end

  test '先頭のアンダーバーを除去する' do
    assert_equal('the_blacklist',
                 Keyword.normalize('_the_blacklist'))
  end

  test '末尾のアンダーバーを除去する' do
    assert_equal('the_blacklist',
                 Keyword.normalize('the_blacklist_'))
  end

  test 'アンダーバーの出現回数の最小化：前に英数字以外の文字' do
    assert_equal('エレメンタリーホームズ&ワトソンin_ny',
                 Keyword.normalize('エレメンタリー__ホームズ___&__ワトソン____in_ny'))
  end

  test 'アンダーバーの出現回数の最小化：後に英数字以外の文字' do
    assert_equal('bones骨は語る',
                 Keyword.normalize('bones__骨は語る'))
  end

  test 'アンダーバーの出現回数の最小化：複合形' do
    assert_equal('テストthe_blacklistテスト',
                 Keyword.normalize('テスト__the___blacklist_テスト'))
  end

  # URL生成で失敗しないように
  test 'ドットを除去する' do
    assert_equal('sword_world_2_0', Keyword.normalize('Sword World 2.0'))
    assert_equal('sword_world_2_0', Keyword.normalize('Sword World 2．0'))
  end

  # URL生成で失敗しないように
  test 'スラッシュを除去する' do
    assert_equal('fate_stay_night', Keyword.normalize('Fate/stay night'))
    assert_equal('fate_stay_night', Keyword.normalize('Fate／stay night'))
  end
end
