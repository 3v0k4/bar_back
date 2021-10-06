module BarBack
  class SqlResult < Result
    def initialize(result, query)
      @result = result
      @query = query
    end

    def active_record_class
      query.active_record_class
    end

    def columns
      result.columns
    end

    def error_message
      ""
    end

    def primary_key
      active_record_class&.primary_key.to_s
    end

    def rows_with_columns
      result.to_a
    end

    def updateable?
      query.updateable?
    end

    def valid?
      true
    end

    def ==(other)
      self.class == other.class &&
        self.result == other.send(:result) &&
        self.query == other.send(:query)
    end

    private

    attr_reader :result, :query
  end
end
