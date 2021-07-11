require "test_helper"

module BarBack
  class EvaluateQueryToCsvStringTest < ActiveSupport::TestCase
    test "with ActiveRecord count" do
      create_user!
      query = Query.new(string: "User.count")

      actual = EvaluateQueryToCsvString.new.call(query)

      expected = CSV.generate { |csv| csv << ["1"] }
      assert_equal expected.strip, actual.strip
    end

    test "with ActiveRecord all" do
      user = create_user!
      query = Query.new(string: "User.all")

      actual = EvaluateQueryToCsvString.new.call(query)

      expected = CSV.generate do |csv|
        csv << ["id", "name", "created_at", "updated_at"]
        csv << [user.id, user.name, user.created_at, user.updated_at]
      end
      assert_equal expected, actual
    end

    test "with ActiveRecord first" do
      user = create_user!
      query = Query.new(string: "User.first")

      actual = EvaluateQueryToCsvString.new.call(query)

      expected = CSV.generate do |csv|
        csv << ["id", "name", "created_at", "updated_at"]
        csv << [user.id, user.name, user.created_at, user.updated_at]
      end
      assert_equal expected, actual
    end

    test "with SQL count" do
      create_user!
      query = Query.new(string: "SELECT COUNT(*) FROM users")

      actual = EvaluateQueryToCsvString.new.call(query)

      expected = CSV.generate do |csv|
        csv << ["COUNT(*)"]
        csv << ["1"]
      end
      assert_equal expected.strip, actual.strip
    end

    test "with SQL all" do
      user = create_user!
      query = Query.new(string: "SELECT * FROM users")

      actual = EvaluateQueryToCsvString.new.call(query)

      expected = CSV.generate do |csv|
        csv << ["id", "name", "created_at", "updated_at"]
        csv << [user.id, user.name, user.created_at.strftime("%F %T.%6N"), user.updated_at.strftime("%F %T.%6N")]
      end
      assert_equal expected, actual
    end

    test "with invalid query" do
      query = Query.new(string: "bad query")

      actual = EvaluateQueryToCsvString.new.call(query)

      assert_equal "", actual.strip
    end

    test "with write ActiveRecord query" do
      create_user!
      query = Query.new(string: "User.destroy_all")

      actual = EvaluateQueryToCsvString.new.call(query)

      assert_equal "", actual.strip
    end

    test "with write SQL query" do
      create_user!
      query = Query.new(string: "DELETE FROM users")

      actual = EvaluateQueryToCsvString.new.call(query)

      assert_equal "", actual.strip
    end
  end
end
