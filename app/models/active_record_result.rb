ActiveRecordResult = Struct.new(:result) do
  def present?
    true
  end

  def columns
    Array(result).first.attribute_names
  end

  def rows
    Array(result).map(&:attributes).map(&:values)
  end
end
