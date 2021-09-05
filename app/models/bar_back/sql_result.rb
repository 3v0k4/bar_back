module BarBack
  SqlResult = Struct.new(:result, :query) do
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

    def active_record_class
      query.active_record_class
    end

    def size
      rows.size
    end
  end
end
