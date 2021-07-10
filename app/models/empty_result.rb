EmptyResult = Class.new do
  def present?
    false
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
end
