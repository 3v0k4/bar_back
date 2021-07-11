module BarBack
  WriteQuery = Struct.new(:error) do
    def present?
      true
    end

    def valid?
      false
    end

    def invalid?
      !valid?
    end

    def error_message
      "can only run read queries: #{error.message}"
    end

    def rows
      []
    end

    def columns
      []
    end
  end
end