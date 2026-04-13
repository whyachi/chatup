class CreateChatupAiAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :chatup_ai_agents do |t|
      t.references :account, null: false, foreign_key: true, index: { unique: true }
      t.references :captain_assistant, null: false, foreign_key: { to_table: :captain_assistants }

      t.string :business_name
      t.string :business_phone
      t.string :business_email
      t.text :business_address
      t.text :business_description

      t.jsonb :working_hours, default: {}, null: false
      t.jsonb :behavior, default: {}, null: false

      t.timestamps
    end
  end
end
