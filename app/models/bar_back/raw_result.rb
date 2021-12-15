module BarBack
  class RawResult < Result
    def initialize(result)
      @result = result
    end

    def active_record_class
      nil
    end

    def columns
      []
    end

    def error_message
      ""
    end

    def primary_key
      ""
    end

    def rows_with_columns
      [{ _column: result.inspect }]
    end

    def updateable?
      false
    end

    def valid?
      true
    end

    def ==(other)
      self.class == other.class &&
        result == other.send(:result)
    end

    private

    attr_reader :result
  end
end
