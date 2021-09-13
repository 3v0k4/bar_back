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
      (rows_with_columns.first || {}).keys
    end

    def rows
      rows_with_columns.map(&:values)
    end

    def rows_with_columns
      Array(result)
        .map(&:attributes)
        .map do |attributes|
          primary_key_value = attributes.fetch(primary_key, nil)
          next attributes unless primary_key_value.nil?
          attributes.reject { |attribute| attribute == primary_key }
        end
    end

    def active_record_class
      query.active_record_class
    end

    def primary_key
      active_record_class.primary_key
    end

    def size
      rows.size
    end

    def updateable?
      query.updateable?
    end
  end
end
