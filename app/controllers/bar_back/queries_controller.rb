require_dependency "bar_back/application_controller"

module BarBack
  class QueriesController < ApplicationController
    def show
      @query = Query.find(id)
      @result = EvaluateQuery.new.call(@query)
    end

    def create
      Query.create!(query_params)
      redirect_to root_path
    end

    def update
      query = Query.find(id)
      query.update!(query_params)
      redirect_to query_path(id: id)
    end

    private

    def query_params
      params.require(:query).permit(:name, :string)
    end

    def id
      params.fetch(:id)
    end
  end
end
