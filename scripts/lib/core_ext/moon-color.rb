module Moon
  class Color

    WHITE = new 1.0, 1.0, 1.0, 1.0

    def coerce(other)
      return self, other
    end

    def -@
      Color.new 1 - r, 1 - g, 1 - b, a
    end

    def +@
      Color.new r.abs, g.abs, b.abs, a.abs
    end

    def +(other)
      ar, ag, ab, aa = *Color.extract(other)
      Color.new r + ar, g + ag, b + ab, a * aa
    end

    def -(other)
      ar, ag, ab, aa = *Color.extract(other)
      Color.new r - ar, g - ag, b - ab, a * aa
    end

    def *(other)
      ar, ag, ab, aa = *Color.extract(other)
      Color.new r * ar, g * ag, b * ab, a * aa
    end

    def /(other)
      ar, ag, ab, aa = *Color.extract(other)
      Color.new r / ar, g / ag, b / ab, a * aa
    end

    alias :abs :+@

  end
end