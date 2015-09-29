class Numeric
  # @param [Numeric] x  target
  # @param [Numeric] d  delta  how much to step by
  # @return [Numeric]
  def step_to(x, d)
    if self > x
      (self - d).max(x)
    elsif self < x
      (self + d).min(x)
    else
      self
    end
  end
end
