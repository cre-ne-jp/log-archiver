# 過去ログのインポート

[irclog2json](https://github.com/cre-ne-jp/irclog2json) を用いて JSON に変換した、Tiarra または Madoka で取得した IRC ログファイルをインポートすることができます。
JSON への変換方法は、変換ツール(irclog2json)の使い方をご覧下さい。

## 使い方

rake タスク **data:import:json** を使います。変換後、以下のコマンドで log-archiver のデータベースにログをインポートします。

```bash
cd /path/to/log-archiver
rails data:import:json[/path/to/json] RAILS_ENV=production
```

## 補助タスクの使い方

インポート用の JSON ファイルを操作して、欠損したユーザー名・ホスト名を補完する補助タスクがあります。

### JSON ファイルを統合する

確実に登録できるときは、1ファイルに結合されていた方が速くデータをインポートできます。

```bash
cd /path/to/log-archiver
rails data:json:concat[/path/to/json/directory] > concated.json
```

### 時系列に並べ替える

補助タスクは、予めメッセージが時系列順に並べ替えられていることを前提に動作します。

```bash
cd /path/to/log-archiver
rails data:json:sort_by_time[/path/to/json] > sorted.json
```

### ユーザー名・ホスト名を補完する

JOIN メッセージを見つけたら nick, user, host の紐付けを記憶します。
PART/QUIT メッセージが見つかるまでに出現した各メッセージの nick を参考に、user, host を追加します。
あくまで推測して補完しているに過ぎませんので、必ずしも正確とは限りません。

```bash
cd /path/to/log-archiver
rails data:json:supplement_user_host[/path/to/json] > supplemented.json
```
