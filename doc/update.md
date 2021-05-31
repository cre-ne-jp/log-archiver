更新
----

バージョン番号の上がりかたで、最低限必要な手順が分かるようになっています。

|  | ライブラリの更新 | データベースのマイグレーション|
| -- | -- | -- |
| マイナーバージョン | o | △ |
| パッチバージョン | o | x |

## ライブラリの更新

### ruby のライブラリ gem の更新

パッケージシステム bundle を使用します。

```bash
bundle install
```

### JavaScript/CSS の更新

開発環境と本番環境でコマンドが変わります。

開発環境の場合

```bash
yarn install
```

本番環境の場合

```bash
# assets:precompile で、yarn install も実行されます
bin/rails assets:{clean,precompile} RAILS_ENV=production
```

### データベースのマイグレーション

データベースの構造の変更が含まれる場合は、マイグレーションが必要になります。

開発環境の場合

```bash
bin/rails db:migrate
```

本番環境の場合

```bash
bin/rails db:migrate RAILS_ENV=production
```
