require_dependency "bar_back/application_controller"

module BarBack
  class PublicQueriesController < ApplicationController
    skip_before_action :authenticate, only: [:show]

    def show
      @query = Query.find_by!(uuid: uuid)
      @result = EvaluateQuery.new.call(@query)
      @record = Record.new(nil)
      respond_to do |format|
        format.html { render 'bar_back/public_queries/show' }
        format.csv { render_csv }
      end
    end

    def update
      method = { private: :private!, public: :public! }.stringify_keys[params.fetch(:visibility)]
      query.public_send(method)
      redirect_to query_records_path(query_id: query.id)
    end

    private

    def id
      @id ||= params.fetch(:id)
    end

    def query
      @query ||= Query.find(id)
    end

    def uuid
      @uuid ||= params.fetch(:uuid)
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
