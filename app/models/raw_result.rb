RawResult = Struct.new(:result) do
  def present?
    true
  end

  def columns
    []
  end

  def rows
    [[result.inspect]]
  end
end
