require_dependency "bar_back/application_controller"

module BarBack
  class RecordsController < ApplicationController
    def create
      active_record_class.create!(record_params)
      redirect_to query_path(id: query_id)
    end

    def update
      active_record_class.find(id).update!(record_params)
      redirect_to query_path(id: query_id)
    end

    def destroy
      active_record_class.find(id).destroy!
      redirect_to query_path(id: query_id)
    end

    private

    def active_record_class
      @active_record_class ||= Query.find(query_id).active_record_class
    end

    def id
      @id ||= params.fetch("id_")
    end

    def query_id
      @query_id ||= params.fetch("query_id")
    end

    def record_params
      @record_params ||= params
        .fetch("record_params")
        .to_unsafe_hash
        .filter { |key| active_record_class.column_names.include?(key) }
    end
  end
end
