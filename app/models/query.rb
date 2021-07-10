Query = Struct.new(:string, keyword_init: true) do
  def empty?
    string.blank?
  end

  def active_record_class
    string.split('.').first || ""
  end

  def active_record?
    klass = BarBack.const_get(active_record_class)
    klass.ancestors.include?(ActiveRecord::Base)
  rescue NameError
    false
  end
end
