module BarBack
  class Query < ApplicationRecord
    def empty?
      string.blank?
    end

    def active_record_class
      class_from_active_record_query || class_from_sql_query
    end

    def active_record?
      !class_from_active_record_query.nil?
    end

    def share!
      update!(uuid: SecureRandom.uuid)
    end

    def unshare!
      update!(uuid: nil)
    end

    def shared?
      !uuid.nil?
    end

    private

    def class_from_active_record_query
      candidate = string.split('.').first || ""
      cast(candidate)
    end

    def class_from_sql_query
      tokens = string.split(" ")
      from_index = tokens.index { |token| Regexp.new(/from/i).match?(token) }
      candidate = tokens[from_index + 1].singularize.capitalize
      cast(candidate)
    end

    def cast(string)
      klass = BarBack.const_get(string) rescue NameError; nil
      klass.ancestors.include?(ActiveRecord::Base) ? klass : nil
    end
  end
end
