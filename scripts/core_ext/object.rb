class Object
  # Checks if the object is kind of (klass), if not raises a TypeError
  #
  # @param [Class] klass
  # @return [self]
  # @raises [TypeError]
  def as(klass)
    if self.kind_of?(klass)
      self
    else
      raise TypeError, "wrong object type #{self.class}, expected #{klass}"
    end
  end
end
