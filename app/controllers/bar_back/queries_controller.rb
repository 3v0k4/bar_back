require_dependency "bar_back/application_controller"

module BarBack
  class QueriesController < ApplicationController
    def show
      @query = query
      @result = EvaluateQuery.new.call(query)

      respond_to do |format|
        format.csv { render_csv }
      end
    end

    def create
      @query = Query.new(query_params)

      if @query.save
        redirect_to query_records_path(query_id: @query.id)
      else
        @queries = Query.all
        render 'bar_back/root/index'
      end
    end

    def update
      @query = query

      if @query.update(query_params)
        redirect_to query_records_path(query_id: @query.id)
      else
        @result = EvaluateQuery.new.call(@query)
        @record = Record.new(nil)
        render 'bar_back/records/index'
      end
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
      @id ||= params.fetch(:id)
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
