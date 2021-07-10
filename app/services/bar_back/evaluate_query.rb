module BarBack
  class EvaluateQuery
    BadQuery = Class.new(StandardError)

    def call(query)
      return NoQuery.new if query.empty?
      cast(evaluate(query))
    rescue ActiveRecord::ReadOnlyError => e
      WriteQuery.new(e)
    rescue BadQuery => e
      InvalidQuery.new(e)
    end

    private

    def evaluate(query)
      ActiveRecord::Base.while_preventing_writes { eval(query.string) }
    rescue ActiveRecord::ReadOnlyError => e
      raise
    rescue StandardError => e
      raise BadQuery.new(e)
    end

    def cast(result)
      if result.is_a?(ActiveRecord::Relation)
        result.empty? ? EmptyResult.new : ActiveRecordResult.new(result)
      elsif result.is_a?(ActiveRecord::Base)
        ActiveRecordResult.new(result)
      else
        RawResult.new(result)
      end
    end
  end
end
