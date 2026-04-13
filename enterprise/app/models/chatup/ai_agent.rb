class Chatup::AiAgent < ApplicationRecord
  self.table_name = 'chatup_ai_agents'

  belongs_to :account
  belongs_to :captain_assistant, class_name: 'Captain::Assistant'

  has_many :documents, through: :captain_assistant, source: :documents
  has_many :inboxes, through: :captain_assistant

  store_accessor :behavior, :tone, :auto_greet, :greeting_message,
                 :auto_handoff, :handoff_message, :out_of_hours_reply,
                 :out_of_hours_message, :collect_contact_info,
                 :product_recommendations, :language

  validates :account_id, presence: true, uniqueness: true
  validates :business_name, presence: true

  before_validation :ensure_captain_assistant
  after_save :sync_to_captain

  private

  def ensure_captain_assistant
    return if captain_assistant.present?

    self.captain_assistant = Captain::Assistant.create!(
      account: account,
      name: business_name || 'AI Agent',
      description: business_description.presence || business_name || 'AI Agent'
    )
  end

  def sync_to_captain
    Chatup::AiAgent::SyncToCaptainService.new(self).perform
  end
end
