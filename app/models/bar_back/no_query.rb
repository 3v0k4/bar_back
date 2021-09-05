module BarBack
  NoQuery = Class.new do
    def valid?
      true
    end

    def invalid?
      !valid?
    end

    def error_message
      ""
    end

    def rows
      []
    end

    def active_record_class
      nil
    end

    def size
      rows.size
    end
  end
end
