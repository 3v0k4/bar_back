module BarBack
  class Result
    def active_record_class
      raise NotImplementedError
    end

    def columns
      raise NotImplementedError
    end

    def error_message
      raise NotImplementedError
    end

    def invalid?
      !valid?
    end

    def primary_key
      raise NotImplementedError
    end

    def rows
      rows_with_columns.map(&:values)
    end

    def rows_with_columns
      raise NotImplementedError
    end

    def size
      rows.size
    end

    def updateable?
      raise NotImplementedError
    end

    def valid?
      raise NotImplementedError
    end

    def ==(other)
      raise NotImplementedError
    end
  end
end
