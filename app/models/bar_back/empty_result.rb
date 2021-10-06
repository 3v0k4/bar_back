module BarBack
  class EmptyResult < Result
    def initialize(query)
      @query = query
    end

    def active_record_class
      query.active_record_class
    end

    def columns
      active_record_class&.column_names || []
    end

    def error_message
      ""
    end

    def primary_key
      ""
    end

    def rows_with_columns
      []
    end

    def updateable?
      query.updateable?
    end

    def valid?
      true
    end

    def ==(other)
      self.class == other.class &&
        self.query == other.send(:query)
    end

    private

    attr_reader :query
  end
end
