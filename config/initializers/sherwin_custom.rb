class String
  def numeric?
    true if self.to_numeric
  end

  def to_numeric
    Float(self) rescue nil
  end
end

