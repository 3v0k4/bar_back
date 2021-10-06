module BarBack
  class EvaluateQuery
    def call(query)
      return NoQuery.new if query.empty?

      if query.active_record?
        evaluate_active_record(query)
      else
        evaluate_sql(query)
      end
    end

    private

    def evaluate_sql(query)
      result = ActiveRecord::Base.while_preventing_writes do
        ActiveRecord::Base.connection.exec_query(query.string)
      end
      result.empty? ? EmptyResult.new(query) : SqlResult.new(result, query)
    rescue ActiveRecord::ReadOnlyError => e
      InvalidQuery.new(e)
    rescue StandardError => e
      InvalidQuery.new(e)
    end

    def evaluate_active_record(query)
      evaluated = ActiveRecord::Base.while_preventing_writes { eval(query.string) }
      cast(evaluated, query)
    rescue ActiveRecord::ReadOnlyError => e
      InvalidQuery.new(e)
    rescue StandardError => e
      InvalidQuery.new(e)
    end

    def cast(result, query)
      if result.is_a?(ActiveRecord::Relation)
        result.empty? ? EmptyResult.new(query) : ActiveRecordResult.new(result, query)
      elsif result.is_a?(ActiveRecord::Base)
        ActiveRecordResult.new(result, query)
      else
        RawResult.new(result)
      end
    end
  end
end
