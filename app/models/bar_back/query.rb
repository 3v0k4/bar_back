module BarBack
  class Query < ApplicationRecord
    def empty?
      string.blank?
    end

    def active_record_class
      string.split('.').first || ""
    end

    def klass
      active_record? ? active_record_class : class_from_sql
    end

    def active_record?
      klass = BarBack.const_get(active_record_class) rescue NameError; false
      klass.ancestors.include?(ActiveRecord::Base)
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

    private

    def class_from_sql
      tokens = string.split(" ")
      from_index = tokens.index { |token| Regexp.new(/from/i).match?(token) }
      candidate = tokens[from_index + 1].singularize.capitalize
      klass_ = BarBack.const_get(candidate) rescue NameError; nil
      klass_.ancestors.include?(ActiveRecord::Base) ? klass_.to_s : nil
    end
  end
end
