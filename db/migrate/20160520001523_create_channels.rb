class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :original
      t.string :downcase
      t.string :alphabet
      t.boolean :enable

      t.timestamps null: false
    end
  end
end
