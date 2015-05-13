#
# EG. @edge_pressure = RectEdgePressureDetector.new(Screen.rect, 24)
#     ...
#     pressure = @edge_pressure.calc(Input::Mouse.position)
#     @model.cam_cursor.position += pressure.xyz * delta * 8
class RectEdgePressureDetector
  attr_accessor :rect
  attr_accessor :range
  attr_accessor :easer

  def initialize(rect, range = 96, easer = Moon::Easing::Linear)
    @range = range
    @easer = easer
    @rect = rect
  end

  def calc(position)
    result = Moon::Vector2.new(0, 0)
    return result unless @rect.contains?(position)
    rel = position - @rect.xy
    if rel.x < range
      result.x = 1 - (rel.x / range.to_f)
    elsif rel.x < @rect.w && rel.x >= (@rect.w-@range)
      result.x = -(1 + (rel.x-@rect.w) / range)
    end
    if rel.y < range
      result.y = 1 - (rel.y / range.to_f)
    elsif rel.y < @rect.h && rel.y >= (@rect.h-@range)
      result.y = -(1 + (rel.y-@rect.h) / range)
    end
    result.set(@easer.call(result.x), @easer.call(result.y))
    -result
  end
end
