module BarBack
  class Query < ApplicationRecord
    validates_presence_of :string
    validates_presence_of :name

    def empty?
      string.blank?
    end

    def active_record_class
      class_from_active_record_query || class_from_sql_query
    end

    def active_record?
      !class_from_active_record_query.nil?
    end

    def public!
      update!(uuid: SecureRandom.uuid)
    end

    def private!
      update!(uuid: nil)
    end

    def public?
      !uuid.nil?
    end

    private

    def class_from_active_record_query
      candidate = string.split('.').first || ""
      cast(candidate)
    end

    def class_from_sql_query
      matches = /from\s(\w+).*/i.match(string)
      return if matches.nil?
      matches
        .captures
        .first
        .singularize
        .camelize
        .yield_self { |string| cast(string) }
    end

    def cast(string)
      klass = BarBack.const_get(string) rescue NameError; nil
      klass.ancestors.include?(ActiveRecord::Base) ? klass : nil
    end
  end
end
