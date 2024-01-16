# テストの実行手順

この文書では、本システムのテストを実行する際の手順を説明します。

v1.2.0以前では、データベース構造の都合上、全文検索エンジンMroongaのエラーを回避するための複雑な手順が必要でしたが、現在は解消されています。

## テストの実行

以下のコマンドによりテストを実行します。

```sh
NODE_ENV=test yarn webpack
bin/rails test
```

実行するテストコードのファイルを指定する場合は、以下のように入力して実行します。

```sh
bin/rails test test/models/conversation_message_test.rb
```
