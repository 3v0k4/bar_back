require_dependency "bar_back/application_controller"

module BarBack
  class QueriesController < ApplicationController
    def show
      @result = EvaluateQuery.new.call(query)

      respond_to do |format|
        format.html
        format.csv { render_csv }
      end

    end

    def create
      Query.create!(query_params)
      redirect_to root_path
    end

    def update
      query.update!(query_params)
      redirect_to query_path(id: id)
    end

    def destroy
      query.destroy!
      redirect_to root_path
    end

    private

    def query_params
      params.require(:query).permit(:name, :string)
    end

    def id
      params.fetch(:id)
    end

    def query
      @query ||= Query.find(id)
    end

    def render_csv
      send_data(
        EvaluateQueryToCsvString.new.call(query),
        type: "text/csv; charset=utf-8; header=present",
        disposition: "attachment; filename=#{query.name}.csv",
        filename: "#{query.name}.csv"
      )
    end
  end
end
