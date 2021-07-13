require_dependency "bar_back/application_controller"

module BarBack
  class RecordsController < ApplicationController
    def update
      active_record_class.find(id).update!(record_params)
      redirect_to query_path(id: query_id)
    end

    private

    def active_record_class
      @active_record_class ||= BarBack.const_get(params.fetch("class_"))
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
