class User < ApplicationRecord
  validates_uniqueness_of :id
  validate do |model|
    model.errors.add(:name, 'cannot be invalid') if model.name == 'invalid'
  end
end
