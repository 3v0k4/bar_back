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

    def has_fields_to_update?
      return false unless active_record_class.present?
      select_values = active_record? ? active_record_select_values : sql_select_values
      select_values.size.zero? ||
        (select_values.size >= 2 && select_values.include?(active_record_class.primary_key))
    end

    private

    def active_record_select_values
      result = eval(string)
      if result.respond_to?(:select_values)
        result.select_values.map(&:to_s)
      elsif result.respond_to?(:attributes)
        result.attributes.keys
      else
        []
      end
    rescue Exception
      []
    end

    def sql_select_values
      match = /select\s+(.+)\s+from/i.match(string)
      return [] if match.nil?
      match
        .captures
        .first
        .split(/\s*,\s*/)
        .filter { |x| x != "*" }
    end

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
