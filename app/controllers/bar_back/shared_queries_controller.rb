require_dependency "bar_back/application_controller"

module BarBack
  class SharedQueriesController < ApplicationController
    skip_before_action :authenticate, only: [:show]

    def show
      @query = Query.find_by!(uuid: uuid)
      @result = EvaluateQuery.new.call(@query)
    end

    def update
      query.share!
      redirect_to query_path(id: query.id)
    end

    def destroy
      query.unshare!
      redirect_to query_path(id: query.id)
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
  end
end
