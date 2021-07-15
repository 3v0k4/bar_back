module BarBack
  class EvaluateQuery
    BadQuery = Class.new(StandardError)

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
      result = evaluate_sql_(query)
      result.empty? ? EmptyResult.new(query) : SqlResult.new(result, query)
    rescue ActiveRecord::ReadOnlyError => e
      # Invalid queries are interpreted as
      # write queries by `while_preventing_writes`,
      # so we won't disambiguate.
      InvalidQuery.new(e)
    rescue BadQuery => e
      InvalidQuery.new(e)
    end

    def evaluate_sql_(query)
      ActiveRecord::Base.while_preventing_writes do
        ActiveRecord::Base.connection.exec_query(query.string)
      end
    rescue StandardError => e
      raise BadQuery.new(e)
    end

    def evaluate_active_record(query)
      cast(evaluate_active_record_(query), query)
    rescue ActiveRecord::ReadOnlyError => e
      WriteQuery.new(e)
    rescue BadQuery => e
      InvalidQuery.new(e)
    end

    def evaluate_active_record_(query)
      ActiveRecord::Base.while_preventing_writes { eval(query.string) }
    rescue ActiveRecord::ReadOnlyError => e
      raise
    rescue StandardError => e
      raise BadQuery.new(e)
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
