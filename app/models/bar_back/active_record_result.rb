module BarBack
  ActiveRecordResult = Struct.new(:result, :query) do
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
      Array(result).first&.attribute_names || []
    end

    def rows
      rows_with_columns.map(&:values)
    end

    def rows_with_columns
      Array(result).map(&:attributes)
    end

    def active_record_class
      query.active_record_class
    end

    def size
      rows.size
    end
  end
end
