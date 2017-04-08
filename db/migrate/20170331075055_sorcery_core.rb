class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # ユーザー名
      t.string :username, null: false, default: ''
      # メールアドレス
      t.string :email, null: false, default: ''
      # 暗号化されたパスワード
      t.string :crypted_password
      # パスワード暗号化用のソルト
      t.string :salt

      t.timestamps                :null => false
    end

    add_index :users, :username, unique: true
  end
end
