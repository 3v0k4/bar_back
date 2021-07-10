module BarBack
  class EvaluateQuery
    def call(query)
      return NoQuery.new if query.empty?
      ActiveRecord::Base.while_preventing_writes { evaluate(query) }
    rescue ActiveRecord::ReadOnlyError => e
      WriteQuery.new(e)
    rescue StandardError => e
      InvalidQuery.new(e)
    end

    private

    def evaluate(query)
      cast(eval(query.string))
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
