module BarBack
  class ActiveRecordResult < Result
    def initialize(result, query)
      @result = result
      @query = query
    end

    def active_record_class
      query.active_record_class
    end

    def columns
      (rows_with_columns.first || {}).keys
    end

    def error_message
      ""
    end

    def primary_key
      active_record_class.primary_key
    end

    def rows_with_columns
      Array(result)
        .map(&:attributes)
        .map do |attributes|
          primary_key_value = attributes.fetch(primary_key, nil)
          next attributes unless primary_key_value.nil?
          attributes.reject { |attribute| attribute == primary_key }
        end
    end

    def updateable?
      query.updateable?
    end

    def valid?
      true
    end

    def ==(other)
      self.class == other.class &&
        result == other.send(:result) &&
        query == other.send(:query)
    end

    private

    attr_reader :result, :query
  end
end
