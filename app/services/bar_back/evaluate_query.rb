module BarBack
  class EvaluateQuery
    def call(query)
      return EmptyResult.new if query.empty?
      evaluate(query)
    rescue StandardError => e
      InvalidQuery.new(e)
    end

    private

    def evaluate(query)
      cast(eval(query.string))
    end

    def cast(result)
      if result.is_a?(ActiveRecord::Relation) || result.is_a?(ActiveRecord::Base)
        ActiveRecordResult.new(result)
      else
        RawResult.new(result)
      end
    end
  end
end
