module BarBack
  RawResult = Struct.new(:result) do
    def valid?
      true
    end

    def invalid?
      !valid?
    end

    def columns
      []
    end

    def rows
      [[result.inspect]]
    end

    def rows_with_columns
      [{ _column: result.inspect }]
    end

    def active_record_class
      nil
    end

    def primary_key
      ""
    end

    def size
      1
    end

    def updateable?
      false
    end
  end
end
