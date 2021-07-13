module BarBack
  SqlResult = Struct.new(:result, :query) do
    def present?
      true
    end

    def valid?
      true
    end

    def invalid?
      !valid?
    end

    def error_message
      ""
    end

    def columns
      result.columns
    end

    def rows
      result.rows
    end

    def rows_with_columns
      result.to_a
    end

    def klass
      query.klass
    end
  end
end
