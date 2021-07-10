module BarBack
  RawResult = Struct.new(:result) do
    def present?
      true
    end

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
  end
end
