# frozen_string_literal: true

require 'test_helper'

module LogArchiver
  class MircToHtmlTest < ActiveSupport::TestCase
    data '太字', [
      "これは \x02太字\x02 です。",
      'これは <span class="mirc-bold">太字</span> です。'
    ]

    data '斜体', [
      "これは \x1D斜体\x1D です。",
      'これは <span class="mirc-italic">斜体</span> です。'
    ]

    data '下線', [
      "以下に\x1F下線が引かれます\x1F。",
      '以下に<span class="mirc-underline">下線が引かれます</span>。'
    ]

    data '打ち消し', [
      "以下は\x1E打ち消されます\x1E。",
      '以下は<span class="mirc-strikethrough">打ち消されます</span>。',
    ]

    data '等幅', [
      "Rubyでは \x11puts()\x11 で文字列を出力できます。",
      'Rubyでは <span class="mirc-monospace">puts()</span> で文字列を出力できます。'
    ]

    data '太字＋斜体＋下線', [
      "重ねて装飾: \x02太字 \x1D斜体 \x1F下線 \x1F下線解除 \x02太字解除 \x1D装飾なし",
      '重ねて装飾: <span class="mirc-bold">太字 </span><span class="mirc-bold mirc-italic">斜体 </span><span class="mirc-bold mirc-italic mirc-underline">下線 </span><span class="mirc-bold mirc-italic">下線解除 </span><span class="mirc-italic">太字解除 </span>装飾なし'
    ]

    data 'リセット', [
      "重ねて装飾: \x02太字 \x1D斜体 \x1F下線 \x0Fまとめてリセット",
      '重ねて装飾: <span class="mirc-bold">太字 </span><span class="mirc-bold mirc-italic">斜体 </span><span class="mirc-bold mirc-italic mirc-underline">下線 </span>まとめてリセット'
    ]

    data '文字色・背景色を設定せず色反転する', [
      "次から \x16色反転\x16 終了",
      '次から 色反転 終了'
    ]

    data '2桁色設定: リセット', [
      "制御文字\x03のみでリセット",
      '制御文字のみでリセット',
    ]

    data '2桁色設定: 文字色1桁', [
      "これは \x030白色\x03 です。",
      'これは <span class="mirc-color00">白色</span> です。'
    ]

    data '2桁色設定: 文字色2桁', [
      "これは \x0301黒色\x03 です。",
      'これは <span class="mirc-color01">黒色</span> です。'
    ]

    data '2桁色設定: 文字色2桁、その後すぐ数字', [
      "これは \x030123黒色\x03 です。",
      'これは <span class="mirc-color01">23黒色</span> です。'
    ]

    data '2桁色設定: カンマのみ', [
      "制御文字後\x03, カンマのみはリセット",
      '制御文字後, カンマのみはリセット'
    ]

    data '2桁色設定: 文字色1桁の後カンマ', [
      "これは\x030,白色\x03です。",
      'これは<span class="mirc-color00">,白色</span>です。'
    ]

    data '2桁色設定: 文字色2桁の後カンマ', [
      "これは\x0301,黒色\x03です。",
      'これは<span class="mirc-color01">,黒色</span>です。'
    ]

    data '2桁色設定: 文字色1桁、背景色1桁', [
      "これは \x030,1文字白色, 背景黒色\x03 です。",
      'これは <span class="mirc-color00 mirc-bg01">文字白色, 背景黒色</span> です。'
    ]

    data '2桁色設定: 文字色1桁、背景色2桁', [
      "これは \x031,00文字黒色, 背景白色\x03 です。",
      'これは <span class="mirc-color01 mirc-bg00">文字黒色, 背景白色</span> です。'
    ]

    data '2桁色設定: 文字色2桁、背景色1桁', [
      "これは \x0300,1文字白色, 背景黒色\x03 です。",
      'これは <span class="mirc-color00 mirc-bg01">文字白色, 背景黒色</span> です。'
    ]

    data '2桁色設定: 文字色2桁、背景色2桁', [
      "これは \x0301,00文字黒色, 背景白色\x03 です。",
      'これは <span class="mirc-color01 mirc-bg00">文字黒色, 背景白色</span> です。'
    ]

    data '2桁色設定: 制御文字後にカンマ数字はリセット', [
      "背景色が\x0300,01設定されそうで\x03,02されない",
      '背景色が<span class="mirc-color00 mirc-bg01">設定されそうで</span>,02されない'
    ]

    data '2桁色設定: 背景色を維持して文字色のみ変更', [
      "ここから\x0300,01文字白色, 背景黒色\x0315, 文字明るいグレー, 背景黒色",
      'ここから<span class="mirc-color00 mirc-bg01">文字白色, 背景黒色</span><span class="mirc-color15 mirc-bg01">, 文字明るいグレー, 背景黒色</span>'
    ]

    data '2桁色設定: 色反転', [
      "これは \x030,1文字白色, 背景黒色, \x16文字黒色, 背景白色, \x16文字白色, 背景黒色\x03 です。",
      'これは ' \
      '<span class="mirc-color00 mirc-bg01">文字白色, 背景黒色, </span>' \
      '<span class="mirc-color01 mirc-bg00">文字黒色, 背景白色, </span>' \
      '<span class="mirc-color00 mirc-bg01">文字白色, 背景黒色</span>' \
      ' です。'
    ]

    data '2桁色設定: 色反転: 色設定後に反転解除', [
      "これは \x030,1\x16文字黒色, 背景白色, \x033,4文字青色, 背景赤色\x03 です。",
      'これは ' \
      '<span class="mirc-color01 mirc-bg00">文字黒色, 背景白色, </span>' \
      '<span class="mirc-color03 mirc-bg04">文字青色, 背景赤色</span>' \
      ' です。'
    ]

    data '16進色設定: リセット', [
      "制御文字\x04のみでリセット",
      '制御文字のみでリセット',
    ]

    data '16進色設定: 文字色', [
      "これは \x04010203ほぼ黒色\x04 です。",
      'これは <span class="mirc-color-hex" style="color: #010203;">ほぼ黒色</span> です。'
    ]

    data '16進色設定: 文字色の後すぐ数字', [
      "これは \x0401020304ほぼ黒色\x04 です。",
      'これは <span class="mirc-color-hex" style="color: #010203;">04ほぼ黒色</span> です。'
    ]

    data '16進色設定: カンマのみ', [
      "制御文字後\x04, カンマのみはリセット",
      '制御文字後, カンマのみはリセット'
    ]

    data '16進色設定: 文字色の後カンマ', [
      "これは \x04010203,ほぼ黒色\x04 です。",
      'これは <span class="mirc-color-hex" style="color: #010203;">,ほぼ黒色</span> です。'
    ]

    data '16進色設定: 文字色と背景色', [
      "これは \x04010203,FFFEFD文字ほぼ黒色, 背景ほぼ白色\x04 です。",
      'これは <span class="mirc-color-hex mirc-bg-hex" style="color: #010203; background-color: #FFFEFD;">文字ほぼ黒色, 背景ほぼ白色</span> です。'
    ]

    data '16進色設定: 制御文字後にカンマ数字はリセット', [
      "背景色が\x04010203,FFFEFD設定されそうで\x04,FFFEFDされない",
      '背景色が<span class="mirc-color-hex mirc-bg-hex" style="color: #010203; background-color: #FFFEFD;">設定されそうで</span>,FFFEFDされない'
    ]

    data '16進色設定: 色反転', [
      "これは \x04FFFEFD,010203文字ほぼ白色, 背景ほぼ黒色, \x16文字ほぼ黒色, 背景ほぼ白色, \x16文字ほぼ白色, 背景ほぼ黒色\x04 です。",
      'これは ' \
      '<span class="mirc-color-hex mirc-bg-hex" style="color: #FFFEFD; background-color: #010203;">文字ほぼ白色, 背景ほぼ黒色, </span>' \
      '<span class="mirc-color-hex mirc-bg-hex" style="color: #010203; background-color: #FFFEFD;">文字ほぼ黒色, 背景ほぼ白色, </span>' \
      '<span class="mirc-color-hex mirc-bg-hex" style="color: #FFFEFD; background-color: #010203;">文字ほぼ白色, 背景ほぼ黒色</span>' \
      ' です。'
    ]

    data '16進色設定: 色反転: 色設定後の反転解除', [
      "これは \x04FFFEFD,010203\x16文字ほぼ黒色, 背景ほぼ白色, \x040000FF,FF0000文字青色, 背景赤色\x04 です。",
      'これは ' \
      '<span class="mirc-color-hex mirc-bg-hex" style="color: #010203; background-color: #FFFEFD;">文字ほぼ黒色, 背景ほぼ白色, </span>' \
      '<span class="mirc-color-hex mirc-bg-hex" style="color: #0000FF; background-color: #FF0000;">文字青色, 背景赤色</span>' \
      ' です。'
    ]

    data "2桁文字色＋2桁背景色設定済み: 非反転: 16進表記リセット", [
      "\x0304,08初期状態\x04設定後",
      "<span class=\"mirc-color04 mirc-bg08\">初期状態</span>設定後"
    ]

    data "2桁文字色＋2桁背景色設定済み: 非反転: 16進文字色のみ", [
      "\x0304,08初期状態\x04010203設定後",
      "<span class=\"mirc-color04 mirc-bg08\">初期状態</span><span class=\"mirc-color-hex mirc-bg08\" style=\"color: #010203;\">設定後</span>"
    ]

    data "2桁文字色＋2桁背景色設定済み: 非反転: 16進文字色と16進背景色", [
      "\x0304,08初期状態\x04010203,FFFEFD設定後",
      "<span class=\"mirc-color04 mirc-bg08\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #010203; background-color: #FFFEFD;\">設定後</span>"
    ]

    data "2桁文字色＋2桁背景色設定済み: 反転: 16進文字色と16進背景色", [
      "\x16\x0304,08初期状態\x04010203,FFFEFD設定後",
      "<span class=\"mirc-color08 mirc-bg04\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #FFFEFD; background-color: #010203;\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 非反転: 2桁表記リセット", [
      "\x04000000,EFED00\x0304初期状態\x03設定後",
      "<span class=\"mirc-color04 mirc-bg-hex\" style=\"background-color: #EFED00;\">初期状態</span>設定後"
    ]

    data "2桁文字色＋16進背景色設定済み: 非反転: 文字色のみ", [
      "\x04000000,EFED00\x0304初期状態\x0300設定後",
      "<span class=\"mirc-color04 mirc-bg-hex\" style=\"background-color: #EFED00;\">初期状態</span><span class=\"mirc-color00 mirc-bg-hex\" style=\"background-color: #EFED00;\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 非反転: 文字色と背景色", [
      "\x04000000,EFED00\x0304初期状態\x0300,01設定後",
      "<span class=\"mirc-color04 mirc-bg-hex\" style=\"background-color: #EFED00;\">初期状態</span><span class=\"mirc-color00 mirc-bg01\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 非反転: 16進表記リセット", [
      "\x04000000,EFED00\x0304初期状態\x04設定後",
      "<span class=\"mirc-color04 mirc-bg-hex\" style=\"background-color: #EFED00;\">初期状態</span>設定後"
    ]

    data "2桁文字色＋16進背景色設定済み: 非反転: 16進文字色のみ", [
      "\x04000000,EFED00\x0304初期状態\x04010203設定後",
      "<span class=\"mirc-color04 mirc-bg-hex\" style=\"background-color: #EFED00;\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #010203; background-color: #EFED00;\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 非反転: 16進文字色と16進背景色", [
      "\x04000000,EFED00\x0304初期状態\x04010203,FFFEFD設定後",
      "<span class=\"mirc-color04 mirc-bg-hex\" style=\"background-color: #EFED00;\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #010203; background-color: #FFFEFD;\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 反転: 文字色のみ", [
      "\x16\x04000000,EFED00\x0304初期状態\x0300設定後",
      "<span class=\"mirc-color-hex mirc-bg04\" style=\"color: #EFED00;\">初期状態</span><span class=\"mirc-color-hex mirc-bg00\" style=\"color: #EFED00;\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 反転: 文字色と背景色", [
      "\x16\x04000000,EFED00\x0304初期状態\x0300,01設定後",
      "<span class=\"mirc-color-hex mirc-bg04\" style=\"color: #EFED00;\">初期状態</span><span class=\"mirc-color01 mirc-bg00\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 反転: 16進文字色のみ", [
      "\x16\x04000000,EFED00\x0304初期状態\x04010203設定後",
      "<span class=\"mirc-color-hex mirc-bg04\" style=\"color: #EFED00;\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #EFED00; background-color: #010203;\">設定後</span>"
    ]

    data "2桁文字色＋16進背景色設定済み: 反転: 16進文字色と16進背景色", [
      "\x16\x04000000,EFED00\x0304初期状態\x04010203,FFFEFD設定後",
      "<span class=\"mirc-color-hex mirc-bg04\" style=\"color: #EFED00;\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #FFFEFD; background-color: #010203;\">設定後</span>"
    ]

    data "16進文字色＋16進背景色設定済み: 非反転: 2桁表記リセット", [
      "\x04FE0102,EFED00初期状態\x03設定後",
      "<span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #FE0102; background-color: #EFED00;\">初期状態</span>設定後"
    ]

    data "16進文字色＋16進背景色設定済み: 非反転: 文字色のみ", [
      "\x04FE0102,EFED00初期状態\x0300設定後",
      "<span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #FE0102; background-color: #EFED00;\">初期状態</span><span class=\"mirc-color00 mirc-bg-hex\" style=\"background-color: #EFED00;\">設定後</span>"
    ]

    data "16進文字色＋16進背景色設定済み: 非反転: 文字色と背景色", [
      "\x04FE0102,EFED00初期状態\x0300,01設定後",
      "<span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #FE0102; background-color: #EFED00;\">初期状態</span><span class=\"mirc-color00 mirc-bg01\">設定後</span>"
    ]

    data "16進文字色＋16進背景色設定済み: 反転: 文字色と背景色", [
      "\x16\x04FE0102,EFED00初期状態\x0300,01設定後",
      "<span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #EFED00; background-color: #FE0102;\">初期状態</span><span class=\"mirc-color01 mirc-bg00\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 非反転: 2桁表記リセット", [
      "\x0399,08\x04FE0102初期状態\x03設定後",
      "<span class=\"mirc-color-hex mirc-bg08\" style=\"color: #FE0102;\">初期状態</span>設定後"
    ]

    data "16進文字色＋2桁背景色設定済み: 非反転: 文字色のみ", [
      "\x0399,08\x04FE0102初期状態\x0300設定後",
      "<span class=\"mirc-color-hex mirc-bg08\" style=\"color: #FE0102;\">初期状態</span><span class=\"mirc-color00 mirc-bg08\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 非反転: 文字色と背景色", [
      "\x0399,08\x04FE0102初期状態\x0300,01設定後",
      "<span class=\"mirc-color-hex mirc-bg08\" style=\"color: #FE0102;\">初期状態</span><span class=\"mirc-color00 mirc-bg01\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 非反転: 16進表記リセット", [
      "\x0399,08\x04FE0102初期状態\x04設定後",
      "<span class=\"mirc-color-hex mirc-bg08\" style=\"color: #FE0102;\">初期状態</span>設定後"
    ]

    data "16進文字色＋2桁背景色設定済み: 非反転: 16進文字色のみ", [
      "\x0399,08\x04FE0102初期状態\x04010203設定後",
      "<span class=\"mirc-color-hex mirc-bg08\" style=\"color: #FE0102;\">初期状態</span><span class=\"mirc-color-hex mirc-bg08\" style=\"color: #010203;\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 非反転: 16進文字色と16進背景色", [
      "\x0399,08\x04FE0102初期状態\x04010203,FFFEFD設定後",
      "<span class=\"mirc-color-hex mirc-bg08\" style=\"color: #FE0102;\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #010203; background-color: #FFFEFD;\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 反転: 文字色のみ", [
      "\x16\x0399,08\x04FE0102初期状態\x0300設定後",
      "<span class=\"mirc-color08 mirc-bg-hex\" style=\"background-color: #FE0102;\">初期状態</span><span class=\"mirc-color08 mirc-bg00\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 反転: 文字色と背景色", [
      "\x16\x0399,08\x04FE0102初期状態\x0300,01設定後",
      "<span class=\"mirc-color08 mirc-bg-hex\" style=\"background-color: #FE0102;\">初期状態</span><span class=\"mirc-color01 mirc-bg00\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 反転: 16進文字色のみ", [
      "\x16\x0399,08\x04FE0102初期状態\x04010203設定後",
      "<span class=\"mirc-color08 mirc-bg-hex\" style=\"background-color: #FE0102;\">初期状態</span><span class=\"mirc-color08 mirc-bg-hex\" style=\"background-color: #010203;\">設定後</span>"
    ]

    data "16進文字色＋2桁背景色設定済み: 反転: 16進文字色と16進背景色", [
      "\x16\x0399,08\x04FE0102初期状態\x04010203,FFFEFD設定後",
      "<span class=\"mirc-color08 mirc-bg-hex\" style=\"background-color: #FE0102;\">初期状態</span><span class=\"mirc-color-hex mirc-bg-hex\" style=\"color: #FFFEFD; background-color: #010203;\">設定後</span>"
    ]

    data 'IRC Formatting Example 1', [
      "I love \x033IRC! \x03It is the \x037best protocol ever!",
      'I love <span class="mirc-color03">IRC! </span>It is the <span class="mirc-color07">best protocol ever!</span>'
    ]

    data 'IRC Formatting Example 2', [
      "This is a \x1D\x0313,9cool \x03message",
      'This is a <span class="mirc-italic mirc-color13 mirc-bg09">cool </span><span class="mirc-italic">message</span>'
    ]

    data 'IRC Formatting Example 3', [
      "IRC \x02is \x034,12so \x03great\x0F!",
      'IRC <span class="mirc-bold">is </span><span class="mirc-bold mirc-color04 mirc-bg12">so </span><span class="mirc-bold">great</span>!'
    ]

    data 'IRC Formatting Example 4', [
      "Rules: Don't spam 5\x0313,8,6\x03,7,8, and especially not \x029\x02\x1D!",
      %q|Rules: Don't spam 5<span class="mirc-color13 mirc-bg08">,6</span>,7,8, and especially not <span class="mirc-bold">9</span><span class="mirc-italic">!</span>|
    ]

    data '#openTRPG 2019-04-29', [
      "\x0311,11\x0311,0\x0311,0",
      ''
    ]

    test 'mIRC制御文字が正しくHTMLに変換される' do
      text_with_mirc_codes, expected = data

      html = MircToHtml.new(text_with_mirc_codes).parse.render
      assert_equal(expected, html)
    end
  end
end
