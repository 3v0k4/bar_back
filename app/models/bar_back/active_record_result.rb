module BarBack
  ActiveRecordResult = Struct.new(:result) do
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
      Array(result).first&.attribute_names || []
    end

    def rows
      rows_with_columns.map(&:values)
    end

    def rows_with_columns
      Array(result).map(&:attributes)
    end
  end
end
