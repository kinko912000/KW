class Object
  def to_b
    compare_value = self.class == String ? self.downcase : self
    case compare_value
    when "yes", "true", "ok", true, "1", 1, :true, :ok, :yes
      true
    else
      false
    end
  end
end