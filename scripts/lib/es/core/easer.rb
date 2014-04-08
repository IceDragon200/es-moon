class Easer

  def initialize
  end

  def ease(a, b, d)
    a + (b - a) * d
  end

end

class Easer::Linear < Easer

  def ease(a, b, d)
    a + (b - a) * d
  end

end