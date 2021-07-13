module BarBack
  NoQuery = Class.new do
    def present?
      false
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

    def active_record_class
      nil
    end
  end
end
