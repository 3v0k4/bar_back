module BarBack
  EmptyResult = Struct.new(:query) do
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
      active_record_class&.column_names || []
    end

    def rows
      [['no results']]
    end

    def rows_with_columns
      [{ _column: 'no results' }]
    end

    def active_record_class
      query.active_record_class
    end
  end
end
