# Delegates to wrapped ActiveRecord model if present.

module BarBack
  class Record
    def initialize(model)
      @model = model
    end

    def error_for(column)
      return "" if model.nil?
      (errors || [])
        .messages_for(column)
        .join(", ")
    end

    def errors_not_for(columns)
      (errors || [])
        .reject { |error| columns.include?(error.attribute.to_s) }
        .map(&:full_message)
        .join(", ")
    end

    def method_missing(sym, *args, &block)
      return nil if model.nil?
      raise NotImplementedError.new(sym) unless model.respond_to?(sym)
      model.public_send(sym)
    end

    private

    attr_reader :model
  end
end
