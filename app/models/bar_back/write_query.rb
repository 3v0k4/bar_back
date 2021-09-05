module BarBack
  WriteQuery = Struct.new(:error) do
    def valid?
      false
    end

    def invalid?
      !valid?
    end

    def error_message
      error.message
    end

    def rows
      []
    end

    def columns
      []
    end

    def active_record_class
      nil
    end
  end
end
