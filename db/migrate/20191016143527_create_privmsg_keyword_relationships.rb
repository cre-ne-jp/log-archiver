class CreatePrivmsgKeywordRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :privmsg_keyword_relationships do |t|
      t.integer :privmsg_id
      t.integer :keyword_id

      t.timestamps null: false
    end

    add_index :privmsg_keyword_relationships, :privmsg_id
    add_index :privmsg_keyword_relationships, :keyword_id
    add_index(:privmsg_keyword_relationships,
              [:privmsg_id, :keyword_id],
              name: 'index_rel_on_privmsg_id_and_keyword_id',
              unique: true)
  end
end
