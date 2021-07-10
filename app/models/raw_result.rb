RawResult = Struct.new(:result) do
  def present?
    true
  end

  def valid?
    true
  end

  def invalid?
    !valid?
  end

  def columns
    []
  end

  def rows
    [[result.inspect]]
  end
end
