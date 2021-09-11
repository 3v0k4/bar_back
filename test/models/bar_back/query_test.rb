require "test_helper"

module BarBack
  class QueryTest < ActiveSupport::TestCase
    test "with a table name with underscores and semicolon at the end it extracts the class" do
      query = Query.new(string: "SELECT * FROM user_with_uids;")

      actual = query.active_record_class

      assert_equal UserWithUid, actual
    end
  end
end
