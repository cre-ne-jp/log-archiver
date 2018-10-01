class CreateSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :settings do |t|
      # サイト名
      t.string :site_title, null: false, default: 'IRC ログアーカイブ'
      # ホームページに表示する文章
      t.text :text_on_homepage, null: false

      t.timestamps null: false
    end
  end
end
