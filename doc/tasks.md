# rake タスクの使い方

lib/tasks に存在する rake タスクの目的と使い方です。

## 目次

* data
  - channel\_last\_speeches
    + update
  - channels
    + prepare\_irc\_cre\_jp
    + initialize\_row\_order
  - conversation\_messages
    + convert
    + delete\_all
  - keywords
    + delete\_all
    + extract\_from\_privmsgs
  - refresh\_digests
    + conversation\_messages
    + messages
    + all


## channel\_last\_speeches

### update

チャンネル別の最終発言キャッシュを、全チャンネル一括更新します。

## channels

### prepare\_irc\_cre\_jp

[irc.cre.jp系IRCサーバ群](https://www.cre.ne.jp/services/irc) での公開チャンネルを一括して登録します。

### initialize\_row\_order

登録されているチャンネルの表示順を初期化します。

## conversation\_messages

### convert

messages テーブルに保存されている全ての PRIVMSG, NOTICE, TOPIC メッセージを、conversation\_messages テーブルに移動します。
過去のバージョンで稼働していたシステムをバージョンアップするために使用します。

### delete\_all

全ての conversation\_messages テーブルに保存されているメッセージを削除します。
データベースやモデルにつけられた外部参照等のためにテーブルやデータベースを削除できないとき、予めこのタスクを実行してみて下さい。

## keywords

### delete\_all

登録されている全てのキーワードと、メッセージとキーワードの紐付けを削除します。
メッセージ本体は削除しません。

### extract\_from\_privmsg

保存されている PRIVMSG から未登録のキーワードを抽出して登録します。
過去のバージョンで稼働していたシステムをバージョンアップするために使用します。

## refresh\_digests

引数として、一度に処理する件数を指定できます。
省略すると 10000 件ずつ処理を行ないます。

### conversation\_messages

conversation\_messages テーブルに保存されているメッセージについて、メッセージダイジェスト値を更新します。
存在しない場合は新規に作成します。
既に付与されている場合は現在の保存値を無視して、再計算した値で上書きします。

### messages

messages テーブルに保存されているメッセージについて、メッセージダイジェスト値を更新します。

### all

上記の conversation\_messages, messages タスクの両方を実行します。
