class CreateChatupBoilerplateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :chatup_boilerplate_items do |t|
      t.references :account, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.jsonb :data, default: {}, null: false

      t.timestamps
    end
  end
end
