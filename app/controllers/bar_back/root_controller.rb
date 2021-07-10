require_dependency "bar_back/application_controller"

module BarBack
  class RootController < ApplicationController
    def index
      @query = Query.new(string: query_string)
      @result = EvaluateQuery.new.call(@query)
    end

    private

    def query_string
      @query_string ||= params.fetch(:query, "")
    end
  end
end
