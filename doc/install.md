# インストール

## 依存する他のプログラム(データベースなど)のインストール

log-archiver は、単独のサーバとして起動します。しかし、直接インターネットからアクセス出来るようにはしないでください(セキュリティ的・パフォーマンス的な問題があります)。
nginx や Apache などのウェブサーバをリバースプロキシとして用意することを強く勧めます。

log-archiver は、チャットログの保存先として、リレーショナルデータベースシステムとして MySQL もしくは MariaDB と、全文検索エンジン Groonga 、RDBMS プラグインとして Groonga を使用するための Mroonga が必要です。
これらのインストールは、[Mroonga 公式サイト](http://mroonga.org/ja/docs/install.html) を参照してください。

log-archiver は Ruby で書かれています。
対応しているバージョンの Ruby 実行環境をインストールし、ライブラリバージョン管理システム Bundler を使えるようにしてください。

log-archiver はバージョン管理システム git で配信されています。git を使ってプログラムをダウンロードする場合は、これもインストールしてください。

## log-archiver のダウンロード

git から直接ダウンロードするには、次のコマンドを実行してください。

```bash
git clone https://github.com/cre-ne-jp/log-archiver.git
cd log-archiver
```

次に、必要なライブラリをダウンロードします。

```bash
bundle install --deployment --path vendor/bundle
```

## データベースの設定

全文検索のため、MySQL/MariaDB の設定を変更する必要があります。
`/etc/my.cnf` や `/etc/my.cnf.d/server` など、ディストリビューションによって書き換えるファイルが違います。
`[mysqld]` で始まる行があるファイルを開き、その行の直後に以下の設定を追記してください。
この設定変更は、MySQL/MariaDB を使う他のプログラムにも影響を与えることがあります。

```conf
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
innodb_file_per_table = 1
innodb_file_format = Barracuda
innodb_large_prefix
```

ファイルを書き換えたら、MySQL/MariaDB を再起動してください。

MySQL もしくは MariaDB にログインし、ユーザーとデータベースを作成します。
データベースアクセスのために作成するユーザーのパスワードは予め作成しておいてください。以下のコマンド例中の <password> は、作成したパスワードを入力します。

```bash
mysql -uroot -p
CREATE DATABASE log_archiver_production;
GRANT ALL PRIVILEGES ON log_archiver_production.* to log_archiver@localhost by '<password>';
flush privileges;
exit;
```

次に、設定ファイルを用意します。

```bash
cp config/database.yml.example config/database.yml
vi config/database.yml
```

一番下の production: から始まる行が、書き換えるデータベース設定です。
`database:`、`username:`、`password:` の3項目を、お使いの環境に合わせて書き換えてください。

最後に、テーブルを作成します。

```bash
bundle exec rake db:migrate RAILS_ENV=production
```

## unicorn の設定

log-archiver のウェブサーバである unicorn の設定です。
まず、設定ファイルを用意します。

```bash
cp config/unicorn.rb.example config/unicorn.rb
```

必要があれば書き換えてください。

## IRC ボットの設定

実際に IRC サーバに接続し、チャットログを収集するボットの設定です。
まず、設定ファイルを用意します。

```bash
cp config/ircbot.yml.example config/ircbot.yml
vi config/ircbot.yml
```
先頭行の `development` を `production` に書き換えます。
末尾にある `production:` と書かれた行を削除します。

他の各項目について、ご利用の環境に合わせて設定を書き換えてください。

log-archiver の IRC ボットは、NickServ にログインして動作する必要があります。予め他のクライアントで IRC サーバに接続し、log-archiver 用のアカウントを作成しておいてください。

## systemd への登録

システム起動時、自動的に log-archiver を起動させるための設定です。
systemd に登録します。

まず、ご自身の環境に合わせて設定ファイルを書き換えます。

```bash
cp doc/log-archiver_* .
vi log-archiver_unicorn.service
vi log-archiver_ircbot.service
```

ruby インタプリタや、log-archiver のパスを確認してください。
終わったら、設定ファイルをシステムに登録します。

```bash
sudo mv log-archiver_unicorn.service log-archiver_ircbot.service /etc/systemd/system/
sudo systemctl daemon-reload
```

## nginx の設定

前述の通り、log-archiver を直接インターネットから接続可能にすることは推奨されません。
ここではリバースプロキシの例として、nginx を例に取ります。

まず、ご自身の環境に合わせて設定ファイルを書き換えます。

```bash
cp doc/nginx/log-archiver-ssl .
vi log-archiver-ssl
```

`upstream` の `server` に指定するのが、log-archiver の unicorn です。
`config/unicorn.rb` に指定した値と同じになるように書き換えます。

`YOUR_SERVER_FQDN` を、log-archiver の URL に書き換えてください。

必要に応じて、`listen` 行に書かれた `default_server` を削除してください。

次に、nginx の設定ディレクトリに設定ファイルを移動し、設定ファイルの書式が間違っていないか確認します。

```bash
sudo mv log-archiver-ssl /etc/nginx/sites-enabled/
nginx -T
```

エラーが出なければ問題ありません。設定ファイルが読み込まれていないときには何のエラーも出ませんので注意してください。

## 動作確認

systemd から起動してみて、エラーが発生しないことを確認してください。
次に、IRC サーバにログインできているか、ウェブサーバにアクセスしてページが表示されるかを確認してください。

問題が無ければ、ウェブインターフェイスからログを収集するチャンネルを作成し、収集を有効にすることで、発言がデータベースに保存されるようになります。
