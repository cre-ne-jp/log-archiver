# IRC ボットの設定

設定ファイルの項目解説です。

## IRCBot

IRC ボットがサーバに接続するための設定を行ないます。

```
IRCBot:
  Host: irc.example.net
  Port: 6667
  Password: pa$$word
  Encoding: UTF-8
  Nick: archiver
  User: archiver
  RealName: LogArchiver
  Channels:
    - ''
```

### Host

必須要素です。
接続する IRC サーバのホスト名を指定します。IP アドレスでも指定できます。

### Port

必須要素です。
IRC サーバのポート番号を指定します。

### Password

必須要素です。
IRC サーバへの接続に必要であれば、文字列を指定してください。
必要ないようなら、'null' を指定してください。

### Encoding

指定されなかった場合、UTF-8 が使用されます。
チャットで使用している文字コードを指定してください。

irc.cre.jp 系IRCサーバ群は UTF-8 を、ircnet や FriendChat では ISO-2022-JP が使用されています。
チャンネルによって複数の文字コードを使い分けることは出来ません。

### Nick / User

必須要素です。
IRC サーバでログ取得ボットが名乗るニックネーム・ユーザー名を指定します。

接続先の IRC ネットワークにより、使用できる文字列の長さが異なります。
大抵の場合、半角英数字と一部の半角記号(IRC ネットワークによって異なる)だけが使えます。

### RealName

必須要素です。
IRC サーバでログ取得ボットが名乗る「本名」を指定します。

接続先の IRC ネットワークによっては、全角文字を使用することも出来ます。
「本名」と呼ばれていますが、必ずしも戸籍名などを書かなければならないわけではありません。

### Channels

ログ取得ボットが、サーバ接続時に自動的に参加するチャンネルを指定します。
ログ取得対象に設定されているチャンネルには、ログ取得中は自動的に参加しますが、それ以外の(例えば当プログラム管理者が管理に使っている)チャンネルに自動参加させるために設定します。

何も設定しなければ、ログ記録対象ではないチャンネルには参加しません。

## AuthenticationServer

IRC管理・運営サービス(Atheme-Services) にログインするための設定を行ないます。

```
AuthenticationServer:
  # NickServ(Atheme-Services) の XMLRPC アドレス
  XMLRPC: 'http://irc.example.com:6667/xmlrpc'
  # ボット自身のアカウント情報
  Account:
    Nick: 'YOUR NICK'
    Pass: 'PA$$WORD'
```

### XMLRPC

Atheme-Services の API のアドレスを指定します。
接続先の IRC サーバ管理者にお問い合わせください。

### Account

NickServ のアカウントを指定します。

log-archiver には IRC に接続して自動的にアカウントを作成する機能はありません。
予め log-archiver に名乗らせるニックネームで IRC サーバに接続し、アカウントを作成しておく必要があります。

## Plugins

プラグインの設定を行ないます。

### ChannelSync

```
ChannelSync:
  # ログ記録が無効なチャンネルから自動的に退出するか
  PartEnable: off
```

ログ記録対象になっていないチャンネルから、自動的に退出するかを設定できます。

on にすると、ログ記録対象ではないチャンネルに参加していた場合、自動的に退出します。
off にすると、ログ記録対象チャンネルへの参加は自動的に行なわれますが、対象外のチャンネルに参加していた場合はそのまま退出しません(退出させるときは後述の Part プラグインを使用するか、KICK します)。

### LoginNickserv

```
LoginNickserv:
  # NickServ の、IRCネットワーク内でのユーザー情報
  NickServ:
    Nick: 'NickServ'
    User: 'NickServ'
    Host: 'services.cre.jp'
  # NickServ がリレーしているサーバアドレス
  LoginServer: 'services.cre.jp'
```

### UserInterface

```
UserInterface:
  # ログ公開URLのホスト名
  # 末尾の / は要りません
  URL: 'https://test.log.cre.ne.jp'
```

IRC 上で、そのチャンネルのログ公開 URL を返すコマンドの設定です。

`.log url` / `.log url list`: そのチャンネルの目次への URL を出力します。
`.log url today`: そのチャンネルの今日のログへの URL を出力します。
`.log url yesterday`: そのチャンネルの昨日のログへの URL を出力します。
`.log url yyyy-mm-dd`: そのチャンネルの指定日のログへの URL を出力します。
`.log status`: そのチャンネルを記録しているかどうかを返します。

出力例

```
< .log url today
> irc.cre.jp ログアーカイブ<URL>: https://log.irc.cre.jp/channels/write/2018/10/04
```

### Part

```
Part:
  # 退出時のメッセージ
  # （IRCプロトコルにおける）PART コマンドの引数として使われます。
  PartMessage: ''
  # コマンドを適用しないチャンネルでコマンドが発言されたときのメッセージ
  LockedMessage: ''
  # ログを取得中のチャンネルでコマンドが発言されたときのメッセージ
  # 取得中のチャンネルでは PartLock に指定されているチャンネルと同様に
  # コマンドを適用しません。
  LoggingMessage: ''
  # 退出コマンドを無条件で使えなくするチャンネル
  PartLock:
    - '#irc_test'
```

発言コマンドで自分から退出させるコマンドの設定です。
