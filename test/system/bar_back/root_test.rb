require "application_system_test_case"

module BarBack
  class RootTest < ApplicationSystemTestCase
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "running queries" do
      user_1 = User.create!(name: "alfie")
      user_2 = User.create!(name: "bettie")

      visit root_path

      fill_in "query", with: "User.all"
      click_button "run"

      assert_equal "User.all", page.find("textarea").value
      assert_text "id"
      assert_text user_1.id
      assert_text user_2.id
      assert_text "name"
      assert_text user_1.name
      assert_text user_2.name
      assert_text "created_at"
      assert_text user_1.created_at
      assert_text user_2.created_at
      assert_text "updated_at"
      assert_text user_1.updated_at
      assert_text user_2.updated_at

      fill_in "query", with: "User.first"
      click_button "run"

      assert_equal "User.first", page.find("textarea").value
      assert_text "id"
      assert_text user_1.id
      assert_text "name"
      assert_text user_1.name
      assert_text "created_at"
      assert_text user_1.created_at
      assert_text "updated_at"
      assert_text user_1.updated_at

      fill_in "query", with: "User.count"
      click_button "run"

      assert_equal "User.count", page.find("textarea").value
      assert_text "2"

      fill_in "query", with: "bad query"
      click_button "run"

      assert_equal "bad query", page.find("textarea").value
      assert_text /invalid query/i

      fill_in "query", with: "User.destroy_all"
      click_button "run"

      assert_equal "User.destroy_all", page.find("textarea").value
      assert_text /can only run read queries/i
    end
  end
end
