# Log Archiver

![Test](https://github.com/cre-ne-jp/log-archiver/workflows/Test/badge.svg)
[![Code Climate](https://codeclimate.com/github/cre-ne-jp/log-archiver/badges/gpa.svg)](https://codeclimate.com/github/cre-ne-jp/log-archiver)
[![Test Coverage](https://codeclimate.com/github/cre-ne-jp/log-archiver/badges/coverage.svg)](https://codeclimate.com/github/cre-ne-jp/log-archiver/coverage)

IRC ボットを常駐させることでチャットログをチャンネル単位で RDBMS に直接記録し、Rails アプリケーションにより記録されたログを整形・表示します。

## 動作環境

* Linux または OSX
* Ruby 2.3.0 以降
* MySQL または MariaDB
* Redis

## インストール

[MySQL](https://www-jp.mysql.com/) もしくは [MariaDB](https://mariadb.org/) と、[Redis](https://redis.io/) をインストールしていない場合はインストールしてください。

全文検索機能を動作させるため、[Groonga](http://groonga.org/ja/) および [Mroonga](http://mroonga.org/ja/) のインストールが必要です。Mroonga 公式サイトより[インストール方法](http://mroonga.org/ja/docs/install.html)を参照してインストールを行ってください。

[Ruby](http://www.ruby-lang.org/) をインストールしていない場合はインストールしてください。

[Bundler](http://bundler.io/) をインストールしていない場合は以下を実行してください。

```bash
gem install bundler
```

上記が完了したら、適当なディレクトリにファイルを設置し、以下を実行して必要な gem（ライブラリ）をインストールしてください。

なお、gem をインストールするためには、システムにいくつかのライブラリと開発環境がインストールされている必要があります。CentOS 7 を最小限構成でセットアップしている場合、以下の追加パッケージが必要です。

* make
* gcc
* gcc-c++
* libicu-devel
* zlib-devel
* mariadb-devel

具体的なインストール手順は [インストール](doc/install.md) を参照してください。

## 設定

* [インストール](doc/install.md)
* [IRC の接続設定](doc/irc.md)
* [ウェブサーバの設定](doc/nginx.md)
* [バックグラウンドジョブの設定](doc/sidekiq.md)

systemd による制御を行なう場合は [systemd](doc/systemd.md) を参照してください。

## IRC ボットの起動

IRC ボットを起動するには、以下を実行してください。Ctrl + C を押すと終了します。

```bash
cd /path/to/log-archiver
bin/ircbot
```

`-c`（`--config`）オプションで、使用する設定を指定することができます。その場合、`-c` に続けて設定 ID を書きます。

```bash
cd /path/to/log-archiver
bin/ircbot -c test # /path/to/log-archiver/config/test.yaml を使用する場合
```

## Web アプリケーションの起動

記録されたログを閲覧するための Web アプリケーションは、Rails アプリケーションとして実装されています。

単体で起動させることもできますが、Apache や nginx からのリバースプロキシ設定を行なうことをお勧めします。

## バックグラウンドジョブの起動

バックグラウンドジョブを実行するためのアプリケーションを起動します。

バックグラウンドジョブを使用しないのであれば、省略可能です。

## 開発者の方へ

テストを実行する際は「[テストの実行手順](doc/testing.md)」を参照してください。

## 素材

閲覧システムのホームページの背景に「[The Die](https://www.flickr.com/photos/n0rfin/8029041600/)」（[Zane Mattingly氏](https://www.flickr.com/photos/n0rfin/)制作；[CC BY-NC-SA 2.0](https://creativecommons.org/licenses/by-nc-sa/2.0/deed.ja)）を利用しています。

## 連絡先

ご意見・ご要望・バグ報告等は、[irc.cre.jp 系 IRC サーバ群](http://www.cre.ne.jp/services/irc)の IRC チャンネル「#cre」や、[GitHub リポジトリ](https://github.com/cre-ne-jp/log-archiver)上の「[Issues](https://github.com/cre-ne-jp/log-archiver/issues)」・「[Pull Requests](https://github.com/cre-ne-jp/log-archiver/pulls)」にて承っております。お気軽にお寄せください。

## ライセンス

* [MIT License](LICENSE)（[日本語](LICENSE.ja)）
* 閲覧システムホームページの背景用として加工された画像（[public/images/the-die-1024-dark.jpg](public/images/the-die-1024-dark.jpg)）については、上記ライセンスを継承した[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ja)とします。

## 制作

&copy; 2017-2019 [クリエイターズネットワーク](http://www.cre.ne.jp/)技術部

* 鯉（[@koi-chan](https://github.com/koi-chan)）
* ocha（[@ochaochaocha3](https://github.com/ochaochaocha3)）
* らぁ（[@raa0121](https://github.com/raa0121)）
