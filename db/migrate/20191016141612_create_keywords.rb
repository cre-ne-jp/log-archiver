class CreateKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :keywords, options: 'ENGINE=Mroonga' do |t|
      t.string :title, null: false, default: ''
      t.string :display_title, null: false, default: ''

      t.timestamps
    end

    add_index :keywords, :title, unique: true
    add_index :keywords, :display_title, type: :fulltext
  end
end
