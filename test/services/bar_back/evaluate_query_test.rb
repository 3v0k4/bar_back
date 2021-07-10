require "test_helper"

module BarBack
  class EvaluateQueryTest < ActiveSupport::TestCase
    test "with an empty query it returns an empty result" do
      query = Query.new(string: "")

      actual = EvaluateQuery.new.call(query)

      assert_equal false, actual.present?
    end

    test "with a valid query it returns a result" do
      query = Query.new(string: "User.all")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.present?
    end

    test "with an invalid query it returns an error" do
      query = Query.new(string: "bad query")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.invalid?
    end

    test "with a write query it returns an error" do
      User.create!
      query = Query.new(string: "User.destroy_all")

      actual = EvaluateQuery.new.call(query)

      assert_equal true, actual.invalid?
    end

    test "it evaluates an ActiveRecord query that returns an ActiveRecord::Relation" do
      User.create!
      query = Query.new(string: "User.all")

      actual = EvaluateQuery.new.call(query)

      expected = ActiveRecordResult.new(User.all)
      assert_equal expected, actual
    end

    test "it evaluates an ActiveRecord query that returns an empty ActiveRecord::Relation" do
      query = Query.new(string: "User.all")

      actual = EvaluateQuery.new.call(query)

      expected = EmptyResult.new
      assert_equal expected, actual
    end

    test "it evaluates an ActiveRecord query and that returns an ActiveRecord::Base" do
      User.create!
      query = Query.new(string: "User.first")

      actual = EvaluateQuery.new.call(query)

      expected = ActiveRecordResult.new(User.first)
      assert_equal expected, actual
    end

    test "it evaluates an ActiveRecord query that returns a raw result" do
      User.create!
      query = Query.new(string: "User.count")

      actual = EvaluateQuery.new.call(query)

      expected = RawResult.new(User.count)
      assert_equal expected, actual
    end
  end
end
