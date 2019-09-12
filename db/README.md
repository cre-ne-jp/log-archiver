# データベーススキーマ・マイグレーション

データベースの初期設定については [doc/install.md](../doc/install.md) を参照してください。

## db/schema.rb について

自動生成される db/schema.rb を使用してデータベースの初期設定を行うとエラーが発生します。このエラーは、Mroonga を使用しているテーブルに後から外部キーを設定する段階で発生するため、Mroonga との相性の悪さといえます。

そのため、db/schema.rb はリポジトリに含めず、データベースの初期設定を必ず

1. `bin/rails db:create`
2. `bin/rails db:migrate`

の順に行うようにしてください。マイグレーションの追加・実行後は、変更点を分かりやすくするため、生成された db/schema.rb を db/schema\_dump.rb に改名して保存しておいてください。
