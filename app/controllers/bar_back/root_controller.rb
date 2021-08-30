require_dependency "bar_back/application_controller"

module BarBack
  class RootController < ApplicationController
    def index
      @query = Query.new
      @queries = Query.all
    end
  end
end
