class UserWithUid < ApplicationRecord
  self.primary_key = :uid

  validates_presence_of :name
  validate do |model|
    model.errors.add(:base, 'base error message') if name == "trigger_base_error"
  end
end
