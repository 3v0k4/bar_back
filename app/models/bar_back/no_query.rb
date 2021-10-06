module BarBack
  class NoQuery < Result
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
      []
    end

    def updateable?
      false
    end

    def valid?
      true
    end

    def ==(other)
      self.class == other.class
    end
  end
end
