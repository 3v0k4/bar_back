require "application_system_test_case"

module BarBack
  class RootTest < ApplicationSystemTestCase
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
      BarBack.http_basic_enabled = false
    end

    test "running queries" do
      user_1 = create_user!
      user_2 = create_user!

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

    test "empty result" do
      visit root_path
      fill_in "query", with: "User.all"

      click_button "run"

      assert_text /no results/i
    end

    test "saving" do
      user = create_user!
      visit root_path

      fill_in "query", with: "User.all"
      click_button "run"

      fill_in "query_name", with: "user-all"
      click_button "save"

      click_link "user-all"

      assert_text "user-all"
      assert_equal "User.all", page.find("textarea").value
      assert_text "id"
      assert_xpath ".//input[@value=#{user.id}]"
      assert_text "name"
      assert_xpath ".//input[@value='#{user.name}']"
      assert_text "created_at"
      assert_xpath ".//input[@value='#{user.created_at}']"
      assert_text "updated_at"
      assert_xpath ".//input[@value='#{user.updated_at}']"

      fill_in "query_string", with: "SELECT * FROM users"
      fill_in "query_name", with: "user-all-sql"
      click_button "save & run"

      assert_text "user-all-sql"
      assert_equal "SELECT * FROM users", page.find("textarea").value
      assert_text "id"
      assert_xpath ".//input[@value=#{user.id}]"
      assert_text "name"
      assert_xpath ".//input[@value='#{user.name}']"
      assert_text "created_at"
      assert_xpath ".//input[@value='#{user.created_at.strftime("%F %T.%6N")}']"
      assert_text "updated_at"
      assert_xpath ".//input[@value='#{user.updated_at.strftime("%F %T.%6N")}']"

      fill_in "query_string", with: "SELECT name FROM users"
      fill_in "query_name", with: "user-all-name"
      click_button "save & run"

      assert_text "user-all-name"
      assert_equal "SELECT name FROM users", page.find("textarea").value
      assert_text "name"
      assert_text user.name

      fill_in "query_string", with: "User.count"
      fill_in "query_name", with: "user-count"
      click_button "save & run"

      assert_text "user-count"
      assert_equal "User.count", page.find("textarea").value
      assert_text "1"

      fill_in "query_string", with: "SELECT COUNT(*) FROM users"
      fill_in "query_name", with: "user-count-sql"
      click_button "save & run"

      assert_text "user-count-sql"
      assert_equal "SELECT COUNT(*) FROM users", page.find("textarea").value
      assert_text "1"

      fill_in "query_string", with: "bad query"
      fill_in "query_name", with: "bad-query"
      click_button "save & run"

      assert_text "bad-query"
      assert_equal "bad query", page.find("textarea").value
      assert_text /invalid query/i

      fill_in "query_string", with: "User.destroy_all"
      fill_in "query_name", with: "write-query"
      click_button "save & run"

      assert_text "write-query"
      assert_equal "User.destroy_all", page.find("textarea").value
      assert_text /can only run read queries/i

      fill_in "query_string", with: "DELETE FROM users"
      fill_in "query_name", with: "write-query-sql"
      click_button "save & run"

      assert_text "write-query-sql"
      assert_equal "DELETE FROM users", page.find("textarea").value
      assert_text /invalid query/i

      fill_in "query_string", with: "User.where(id: nil)"
      fill_in "query_name", with: "empty"
      click_button "save & run"

      assert_text "empty"
      assert_equal "User.where(id: nil)", page.find("textarea").value
      assert_text /no results/i

      fill_in "query_string", with: "SELECT * FROM users WHERE id = NULL"
      fill_in "query_name", with: "empty-sql"
      click_button "save & run"

      assert_text "empty-sql"
      assert_equal "SELECT * FROM users WHERE id = NULL", page.find("textarea").value
      assert_text /no results/i

      fill_in "query_string", with: ""
      fill_in "query_name", with: "empty-query"
      click_button "save & run"

      assert_text "empty-query"
      assert_equal "", page.find("textarea").value
    end

    test "csv" do
      user = create_user!
      visit root_path

      fill_in "query", with: "User.all"
      click_button "run"

      fill_in "query_name", with: "user-all"
      click_button "save"

      click_link "user-all"

      assert_link "csv"

      click_link "csv"
      sleep 1

      expected = <<~CSV
        id,name,created_at,updated_at
        #{user.id},#{user.name},#{user.created_at},#{user.updated_at}
      CSV
      assert_equal expected, File.read("#{DOWNLOAD_PATH}/user-all.csv")
    end

    test "deleting queries" do
      visit root_path

      fill_in "query", with: "User.all"
      click_button "run"

      fill_in "query_name", with: "user-all"
      click_button "save"

      click_link "user-all"

      accept_alert do
        click_button "delete"
      end

      visit root_path

      assert_no_text "user-all"
    end

    test "sharing" do
      user = create_user!

      visit root_path

      fill_in "query", with: "User.all"
      click_button "run"

      fill_in "query_name", with: "user-all"
      click_button "save"

      click_link "user-all"

      click_button "share"

      assert_button "unshare"

      click_button "unshare"

      assert_button "share"

      click_button "share"
      click_link "public"

      assert_text "User.all"
      assert_text "id"
      assert_text user.id
      assert_text "name"
      assert_text user.name
      assert_text "created_at"
      assert_text user.created_at
      assert_text "updated_at"
      assert_text user.updated_at

      click_link "csv"
      sleep 1

      expected = <<~CSV
        id,name,created_at,updated_at
        #{user.id},#{user.name},#{user.created_at},#{user.updated_at}
      CSV
      assert_equal expected, File.read("#{DOWNLOAD_PATH}/user-all.csv")
    end
  end
end
