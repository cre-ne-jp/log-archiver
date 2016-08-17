# Log Archiver

IRC ボットを常駐させることでチャットログをチャンネル単位で RDBMS に直接記録し、Rails アプリケーションにより記録されたログを整形・表示します。


## 動作環境

* Linux または MacOSX  
  * 現在のところ Windows には未対応。
* Ruby 2.1.0 以降
* MySQL または MariaDB


# インストール

[MySQL](https://www-jp.mysql.com/) もしくは [MariaDB](https://mariadb.org/) をインストールしていない場合はインストールしてください。

[Ruby](http://www.ruby-lang.org/) をインストールしていない場合はインストールしてください。

[Bundler](http://bundler.io/) をインストールしていない場合は以下を実行してください。

```bash
gem install bundler
```

上記が完了したら、適当なディレクトリにファイルを設置し、以下を実行して必要な gem（ライブラリ）をインストールしてください。

なお、gem をインストールするためには、システムにいくつかのライブラリと開発環境がインストールされている必要があります。  
CentOS 7 を最小限構成でセットアップしている場合、以下の追加パッケージが必要です。

* make
* gcc
* gcc-c++
* libicu-devel
* zlib-devel
* mariadb-devel

```bash
cd /path/to/log-archiver
```


## 設定

* [IRC の接続設定](doc/irc.md)
* [データベースの接続設定](doc/database.md)
* [ウェブサーバの設定](doc/nginx.md)


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

systemd による制御を行なう場合は [systemd](doc/systemd.md) を参照してください。


## 出力部の起動

出力部は Rails アプリケーションとして実装されています。

単体で起動させることもできますが、[Apache]() や [nginx]() からのリバースプロキシ設定を行なうことをお勧めします。


## 連絡先

ご意見・ご要望・バグ報告等は、[irc.cre.jp 系 IRC サーバ群](http://www.cre.ne.jp/services/irc)の IRC チャンネル「#cre」や、[GitHub リポジトリ](https://github.com/cre-ne-jp/log-archiver)上の「[Issues](https://github.com/cre-ne-jp/log-archiver/issues)」・「[Pull Requests](https://github.com/cre-ne-jp/log-archiver/pulls)」にて承っております。お気軽にお寄せください。

ライセンス
----------

[MIT License](LICENSE)（[日本語](LICENSE.ja)）

制作
----

&copy; 2014-2016 [クリエイターズネットワーク](http://www.cre.ne.jp/)技術部

* 鯉（[@koi-chan](https://github.com/koi-chan)）
* ocha（[@ochaochaocha3](https://github.com/ochaochaocha3)）