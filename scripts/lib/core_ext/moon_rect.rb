module Moon
  class Rect

    def contract(n)
      n = n.to_i
      self.x += n
      self.y += n
      self.width -= n * 2
      self.height -= n * 2
      self
    end

  end
end