require "application_system_test_case"

module BarBack
  class RootTest < ApplicationSystemTestCase
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
      BarBack.http_basic_enabled = false
    end

    test "no saved queries" do
      visit root_path

      assert_text /save some queries to see them here/i
    end

    test "list of queries" do
      user = create_user!
      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      visit root_path

      assert_text "User.all"
      assert_text "user-all"
      assert_text /private/i

      click_link "user-all"
      find("label", text: "Public").click
      visit root_path

      assert_text /public/i
    end

    test "delete query" do
      user = create_user!
      visit root_path
      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"
      visit root_path

      accept_alert do
        click_button "Delete"
      end

      assert_text /save some queries to see them here/i
    end

    test "empty result" do
      visit root_path
      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      assert_text /no results/i
    end

    test "saving" do
      user_1 = create_user!
      user_2 = create_user!
      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      visit root_path
      click_link "user-all"

      assert_text "user-all"
      assert_equal "User.all", page.find("textarea").value
      assert_text "id"
      assert_xpath ".//input[@value=#{user_1.id}]"
      assert_xpath ".//input[@value=#{user_2.id}]"
      assert_text "name"
      assert_xpath ".//input[@value='#{user_1.name}']"
      assert_xpath ".//input[@value='#{user_2.name}']"
      assert_text "created_at"
      assert_xpath ".//input[@value='#{user_1.created_at}']"
      assert_xpath ".//input[@value='#{user_2.created_at}']"
      assert_text "updated_at"
      assert_xpath ".//input[@value='#{user_1.updated_at}']"
      assert_xpath ".//input[@value='#{user_2.updated_at}']"

      fill_in "query_string", with: "SELECT * FROM users"
      fill_in "query_name", with: "user-all-sql"
      click_button "Save"

      assert_text "user-all-sql"
      assert_equal "SELECT * FROM users", page.find("textarea").value
      assert_text "id"
      assert_xpath ".//input[@value=#{user_1.id}]"
      assert_xpath ".//input[@value=#{user_2.id}]"
      assert_text "name"
      assert_xpath ".//input[@value='#{user_1.name}']"
      assert_xpath ".//input[@value='#{user_2.name}']"
      assert_text "created_at"
      assert_xpath ".//input[@value='#{user_1.created_at.strftime("%F %T.%6N")}']"
      assert_xpath ".//input[@value='#{user_2.created_at.strftime("%F %T.%6N")}']"
      assert_text "updated_at"
      assert_xpath ".//input[@value='#{user_1.updated_at.strftime("%F %T.%6N")}']"
      assert_xpath ".//input[@value='#{user_2.updated_at.strftime("%F %T.%6N")}']"

      fill_in "query_string", with: "User.first"
      fill_in "query_name", with: "user-first"
      click_button "Save"

      assert_text "user-first"
      assert_equal "User.first", page.find("textarea").value
      assert_text "id"
      assert_xpath ".//input[@value=#{user_1.id}]"
      assert_text "name"
      assert_xpath ".//input[@value='#{user_1.name}']"
      assert_text "created_at"
      assert_xpath ".//input[@value='#{user_1.created_at}']"
      assert_text "updated_at"
      assert_xpath ".//input[@value='#{user_1.updated_at}']"

      fill_in "query_string", with: "SELECT name FROM users"
      fill_in "query_name", with: "user-all-name"
      click_button "Save"

      assert_text "user-all-name"
      assert_equal "SELECT name FROM users", page.find("textarea").value
      assert_text "name"
      assert_text user_1.name
      assert_text user_2.name

      fill_in "query_string", with: "User.count"
      fill_in "query_name", with: "user-count"
      click_button "Save"

      assert_text "user-count"
      assert_equal "User.count", page.find("textarea").value
      assert_text "2"

      fill_in "query_string", with: "SELECT COUNT(*) FROM users"
      fill_in "query_name", with: "user-count-sql"
      click_button "Save"

      assert_text "user-count-sql"
      assert_equal "SELECT COUNT(*) FROM users", page.find("textarea").value
      assert_text "2"

      fill_in "query_string", with: "bad query"
      fill_in "query_name", with: "bad-query"
      click_button "Save"

      assert_text "bad-query"
      assert_equal "bad query", page.find("textarea").value
      assert_text /error/i

      fill_in "query_string", with: "User.destroy_all"
      fill_in "query_name", with: "write-query"
      click_button "Save"

      assert_text "write-query"
      assert_equal "User.destroy_all", page.find("textarea").value
      assert_text /can only run read queries/i

      fill_in "query_string", with: "DELETE FROM users"
      fill_in "query_name", with: "write-query-sql"
      click_button "Save"

      assert_text "write-query-sql"
      assert_equal "DELETE FROM users", page.find("textarea").value
      assert_text /error/i

      fill_in "query_string", with: "User.where(id: nil)"
      fill_in "query_name", with: "empty"
      click_button "Save"

      assert_text "empty"
      assert_equal "User.where(id: nil)", page.find("textarea").value
      assert_text /no results/i

      fill_in "query_string", with: "SELECT * FROM users WHERE id = NULL"
      fill_in "query_name", with: "empty-sql"
      click_button "Save"

      assert_text "empty-sql"
      assert_equal "SELECT * FROM users WHERE id = NULL", page.find("textarea").value
      assert_text /no results/i
    end

    test "csv" do
      user = create_user!
      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      assert_link "Export CSV"

      click_link "Export CSV"
      sleep 1

      expected = <<~CSV
        id,name,created_at,updated_at
        #{user.id},#{user.name},#{user.created_at},#{user.updated_at}
      CSV
      assert_equal expected, File.read("#{DOWNLOAD_PATH}/user-all.csv")
    end

    test "deleting queries" do
      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      accept_alert do
        click_link "Delete"
      end

      visit root_path

      assert_no_text "user-all"
    end

    test "sharing" do
      user = create_user!

      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      assert_text <<~EOF
        The result of the query is currently private.
        You can generate a random public link to a read-only view.
      EOF

      find("label", text: "Public").click

      #assert_button "Private"

      find("label", text: "Private").click

      #assert_button "Public"

      find("label", text: "Public").click
      window = window_opened_by do
        click_link public_query_path(id: Query.last.id, uuid: Query.last.uuid)
      end

      within_window(window) do
        assert_text Query.last.name
        assert_text Query.last.string
        assert_text /results \(1\)/i
        assert_text "User.all"
        assert_text "id"
        assert_text user.id
        assert_text "name"
        assert_text user.name
        assert_text "created_at"
        assert_text user.created_at
        assert_text "updated_at"
        assert_text user.updated_at

        click_link "Export CSV"
        sleep 1

        expected = <<~CSV
          id,name,created_at,updated_at
          #{user.id},#{user.name},#{user.created_at},#{user.updated_at}
        CSV
        assert_equal expected, File.read("#{DOWNLOAD_PATH}/user-all.csv")
      end
    end

    test "update single record" do
      user = create_user!

      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      new_id = random_int
      fill_in "id-#{user.id}", with: new_id
      new_name = random_string
      fill_in "name-#{user.id}", with: new_name
      new_created_at = random_time
      fill_in "created_at-#{user.id}", with: new_created_at
      new_updated_at = random_time
      fill_in "updated_at-#{user.id}", with: new_updated_at

      click_button "update-#{user.id}"

      user = User.first
      assert_equal new_id, user.id
      assert_equal new_name, user.name
      assert_equal new_created_at.to_i, user.created_at.to_i
      assert_equal new_updated_at.to_i, user.updated_at.to_i

      fill_in "query_string", with: "SELECT * FROM users"
      click_button "Save"

      new_id = random_int
      fill_in "id-#{user.id}", with: new_id
      new_name = random_string
      fill_in "name-#{user.id}", with: new_name
      new_created_at = random_time
      fill_in "created_at-#{user.id}", with: new_created_at
      new_updated_at = random_time
      fill_in "updated_at-#{user.id}", with: new_updated_at

      click_button "update-#{user.id}"

      user = User.first
      assert_equal new_id, user.id
      assert_equal new_name, user.name
      assert_equal new_created_at.to_i, user.created_at.to_i
      assert_equal new_updated_at.to_i, user.updated_at.to_i
    end

    test "delete single record" do
      user = create_user!

      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      accept_alert do
        click_link "delete-#{user.id}"
      end
      sleep 1

      assert_equal 0, User.count

      user = create_user!

      fill_in "query_string", with: "SELECT * FROM users"
      click_button "Save"

      accept_alert do
        click_link "delete-#{user.id}"
      end
      sleep 1

      assert_equal 0, User.count
    end

    test "create single record" do
      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      fill_in "name-new", with: random_string
      click_button "create"

      assert_equal 1, User.count

      fill_in "query_string", with: "SELECT * FROM users"
      click_button "Save"

      fill_in "name-new", with: random_string
      click_button "create"

      assert_equal 2, User.count
    end

    test "shows error on create and update" do
      user1 = create_user!
      user2 = create_user!

      visit root_path

      fill_in "query_string", with: "User.all"
      fill_in "query_name", with: "user-all"
      click_button "Save"

      fill_in "id-new", with: user1.id
      click_button "create"

      assert_equal 2, User.count
      assert_text /id has already been taken/i

      fill_in "id-#{user2.id}", with: user1.id
      click_button "update-#{user2.id}"

      assert_text /id has already been taken/i
    end

    test 'with missing from' do
      visit root_path

      fill_in "query_string", with: "SELECT 123 ONE"
      fill_in "query_name", with: "select"
      click_button "Save"

      assert_text "123"
      assert_text "ONE"
    end
  end
end
