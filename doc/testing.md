# テストの実行手順

この文書では、本システムのテストを実行する際の手順を説明します。

本システムで使用しているフレームワークRuby on Rails v6と全文検索エンジンMroongaの相性の悪さのため、テストの実行手順が複雑になっています。通常はコマンド `bin/rails test` のみでテストを実行できますが、本システムにおいては以下の手順でテストを実行してください。

## テスト用データベースの削除

既にテスト用データベースが存在し、それを削除したい場合は以下のコマンドを実行してください（通常時および初回実行時は必要ありません）。エラーが発生した場合は複数回実行してください。

```sh
bin/rails db:drop RAILS_ENV=test
# Dropped database 'log_archiver_test'
```

エラーが発生する場合、多くは、Mroongaを使用するテーブルにおいて関係が存在する列を削除できないというエラーです。通常は `db:drop` を複数回実行することで解消できます。

まれにRailsのモデルと対応しない名前のテーブルが残る場合があります（外部キー制約が原因となるようです）。その場合、MySQLのコンソールを起動して以下のコマンドを実行すると解消できる可能性があります。

```sql
-- Mroonga上に残っているテーブルを確認する
SELECT mroonga_command("table_list");

-- 原因のテーブルを削除する
SELECT mroonga_command("table_remove テーブル名");
```

## テスト用データベースの準備

初回実行時、または上記の手順でテスト用データベースを削除した場合は以下のコマンドを実行し、テスト用データベースの作成およびマイグレーションを行います。

```sh
bin/rails db:create RAILS_ENV=test
# Created database 'log_archiver_test'

bin/rails db:migrate RAILS_ENV=test
# マイグレーションの経過が表示される
```

## テスト用データベースに対するマイグレーション

開発中にデータベースのマイグレーションを作成し、それを適用する必要がある場合は、以下のコマンドによりテスト用データベースに対して手動で適用してください。

```sh
bin/rails db:migrate RAILS_ENV=test
```

## テストの実行

上記の準備がすべて終了した後、以下のコマンドによりテストを実行します。

```sh
bin/rails test
```

実行するテストコードのファイルを指定する場合は、以下のように入力して実行します。

```sh
bin/rails test test/models/conversation_message_test.rb
```
