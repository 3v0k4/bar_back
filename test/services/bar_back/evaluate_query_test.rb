require "test_helper"

module BarBack
  class EvaluateQueryTest < ActiveSupport::TestCase
    test "with a valid ActiveRecord query it returns a result" do
      query = Query.new(string: "User.all")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.present?
    end

    test "with a valid SQL query it returns a result" do
      query = Query.new(string: "SELECT * FROM users")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.present?
    end

    test "with an invalid query it returns an error" do
      query = Query.new(string: "bad query")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.invalid?
    end

    test "with a write ActiveRecord query it returns an error" do
      create_user!
      query = Query.new(string: "User.destroy_all")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.invalid?
    end

    test "with a write SQL query it returns an error" do
      create_user!
      query = Query.new(string: "DELETE FROM users")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.invalid?
    end

    test "it evaluates an ActiveRecord query that returns an ActiveRecord::Relation" do
      create_user!
      query = Query.new(string: "User.all")

      actual = EvaluateQuery.new.call(query)

      expected = ActiveRecordResult.new(User.all, query)
      assert_equal expected, actual
    end

    test "it evaluates an ActiveRecord query that returns an empty ActiveRecord::Relation" do
      query = Query.new(string: "User.all")

      actual = EvaluateQuery.new.call(query)

      expected = EmptyResult.new(query)
      assert_equal expected, actual
    end

    test "it evaluates an ActiveRecord query and that returns an ActiveRecord::Base" do
      create_user!
      query = Query.new(string: "User.first")

      actual = EvaluateQuery.new.call(query)

      expected = ActiveRecordResult.new(User.first, query)
      assert_equal expected, actual
    end

    test "it evaluates an ActiveRecord query that returns a raw result" do
      create_user!
      query = Query.new(string: "User.count")

      actual = EvaluateQuery.new.call(query)

      expected = RawResult.new(User.count)
      assert_equal expected, actual
    end

    test "it evaluates a SQL query that returns a collection" do
      create_user!
      query = Query.new(string: "SELECT * FROM users")

      actual = EvaluateQuery.new.call(query)

      assert_equal User.attribute_names, actual.columns
      assert_equal [User.first.attributes.values], actual.rows
    end

    test "it evaluates a SQL query that returns an empty result" do
      query = Query.new(string: "SELECT * FROM users")

      actual = EvaluateQuery.new.call(query)

      assert_equal ["id", "name", "created_at", "updated_at"], actual.columns
      assert_equal [], actual.rows
    end

    test "it evaluates a SQL query that returns an empty result for a table that does not exist" do
      query = Query.new(string: "SELECT * FROM userz")

      actual = EvaluateQuery.new.call(query)

      assert_equal [], actual.columns
      assert_equal [], actual.rows
    end
  end
end
