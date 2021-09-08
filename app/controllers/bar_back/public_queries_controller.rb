require_dependency "bar_back/application_controller"

module BarBack
  class PublicQueriesController < ApplicationController
    skip_before_action :authenticate, only: [:show]

    def show
      @query = Query.find_by!(uuid: uuid)
      @result = EvaluateQuery.new.call(@query)
    end

    def update
      method = { private: :private!, public: :public! }.stringify_keys[params.fetch(:visibility)]
      query.send(method)
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
  end
end
