class User
  def self.human_attribute_name(attribute)
    attribute.to_s.humanize
  end
end
