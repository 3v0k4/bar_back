require "application_system_test_case"

module BarBack
  class RootTest < ApplicationSystemTestCase
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "running queries" do
      visit root_path
    end
  end
end
