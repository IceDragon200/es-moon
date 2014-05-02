module Moon
  class Color

    def -@
      Color.new 1 - r, 1 - g, 1 - b, a
    end

    def +@
      Color.new r, g, b, a
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

    class << self

      def extract(other)
        case other
        when Color then return *other
        when Array then
          r, g, b, a = *other
          a ||= 1.0
          return r, g, b, a
        when Numeric then return other, other, other, 1.0
        else
          raise TypeError,
                "wrong argument type #{obj.class} (expected Color, Array or Numeric)"
        end
      end unless method_defined? :extract

    end

  end
end