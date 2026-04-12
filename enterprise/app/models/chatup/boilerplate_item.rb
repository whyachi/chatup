class Chatup::BoilerplateItem < ApplicationRecord
  self.table_name = 'chatup_boilerplate_items'

  belongs_to :account

  validates :name, presence: true
end
