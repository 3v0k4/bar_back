require_dependency "bar_back/application_controller"

module BarBack
  class RecordsController < ApplicationController
    def index
      @query = query
      @result = EvaluateQuery.new.call(query)
      @for = :index
    end

    def new
      @query = query
      @result = EvaluateQuery.new.call(query)
      @for = :new
      render 'bar_back/records/index'
    end

    def create
      record = active_record_class.new(record_params)

      if record.save
        redirect_to query_records_path(query_id: query_id)
      else
        rerender(record, :new)
      end
    end

    def update
      record = active_record_class.find(id)

      if record.update(record_params)
        redirect_to query_records_path(query_id: query_id)
      else
        rerender(record, :index)
      end
    end

    def destroy
      active_record_class.find(id).destroy!
      redirect_to query_records_path(query_id: query_id)
    end

    private

    def active_record_class
      @active_record_class ||= query.active_record_class
    end

    def id
      @id ||= params.fetch("id_")
    end

    def query_id
      @query_id ||= params.fetch("query_id")
    end

    def query
      @query ||= Query.find(query_id)
    end

    def record_params
      @record_params ||= params
        .fetch("record_params")
        .to_unsafe_hash
        .filter { |key| active_record_class.column_names.include?(key) }
    end

    def rerender(record, for_)
      @query = query
      @result = EvaluateQuery.new.call(@query)
      @record = record
      @for = for_
      render 'bar_back/records/index'
    end
  end
end
