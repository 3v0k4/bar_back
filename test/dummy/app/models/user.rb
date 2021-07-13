class User < ApplicationRecord
  validates_uniqueness_of :id
end
