module BarBack
  EmptyResult = Struct.new(:query) do
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
      []
    end

    def rows_with_columns
      []
    end

    def active_record_class
      query.active_record_class
    end

    def size
      rows.size
    end
  end
end
