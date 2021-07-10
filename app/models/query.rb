Query = Struct.new(:string, keyword_init: true) do
  def empty?
    string.blank?
  end
end
