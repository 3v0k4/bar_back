require "test_helper"

module BarBack
  class ActiveRecordResultTest < ActiveSupport::TestCase
    test "#rows_with_columns skips primary_key when nil" do
      user = create_user!
      query = Query.new(string: "User.select(:name)")
      active_record_result = ActiveRecordResult.new(User.select(:name), query)

      actual = active_record_result.rows_with_columns

      assert_equal [{ 'name' => user.name }], actual
    end

    test "#columns skips primary_key when nil" do
      user = create_user!
      query = Query.new(string: "User.select(:name)")
      active_record_result = ActiveRecordResult.new(User.select(:name), query)

      actual = active_record_result.columns

      assert_equal ['name'], actual
    end
  end
end
