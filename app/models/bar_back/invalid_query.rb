module BarBack
  class InvalidQuery < Result
    def initialize(error)
      @error = error
    end

    def active_record_class
      nil
    end

    def columns
      []
    end

    def error_message
      error.message
    end

    def primary_key
      ""
    end

    def rows_with_columns
      []
    end

    def updateable?
      false
    end

    def valid?
      false
    end

    def ==(other)
      self.class == other.class &&
        self.error == other.send(:error)
    end

    private

    attr_reader :error
  end
end
