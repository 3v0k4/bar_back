EmptyResult = Class.new do
  def ==(other)
    other.class == EmptyResult
  end

  def present?
    true
  end

  def valid?
    true
  end

  def invalid?
    !valid?
  end

  def error_message
    ""
  end

  def columns
    []
  end

  def rows
    [['no results']]
  end
end
