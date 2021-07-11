require "csv"

module BarBack
  class EvaluateQueryToCsvString
    def initialize(evaluate_query: EvaluateQuery.new)
      @evaluate_query = evaluate_query
    end

    def call(query)
      result = @evaluate_query.call(query)

      CSV.generate do |csv|
        csv << result.columns
        result.rows.each { |row| csv << row }
      end
    end
  end
end
