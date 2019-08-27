# 過去ログのインポート

[irclog2json](https://github.com/cre-ne-jp/irclog2json) を用いて JSON に変換した、Tiarra または Madoka で取得した IRC ログファイルをインポートすることができます。
JSON への変換方法は、変換ツール(irclog2json)の使い方をご覧下さい。

## 使い方

rake タスク **data:import:json** を使います。変換後、以下のコマンドで log-archiver のデータベースにログをインポートします。

```bash
cd /path/to/log-archiver
rails data:import:json[/path/to/yyyymmdd.json] RAILS_ENV=production
```
