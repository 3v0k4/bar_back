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
      SqlResult.new(evaluate_sql_(query))
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
      cast(evaluate_active_record_(query))
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
