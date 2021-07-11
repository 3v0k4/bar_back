module BarBack
  class Query < ApplicationRecord
    def empty?
      string.blank?
    end

    def active_record_class
      string.split('.').first || ""
    end

    def active_record?
      klass = BarBack.const_get(active_record_class)
      klass.ancestors.include?(ActiveRecord::Base)
    rescue NameError
      false
    end

    def share!
      update!(uuid: SecureRandom.uuid)
    end

    def unshare!
      update!(uuid: nil)
    end

    def shared?
      uuid.nil?
    end
  end
end
