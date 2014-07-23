#
# EG. @edge_pressure = RectEdgePressureDetector.new(Screen.rect, 24)
#     ...
#     pressure = @edge_pressure.calc(Input::Mouse.position)
#     @model.cam_cursor.position += pressure.xyz * delta * 8
class RectEdgePressureDetector
  attr_accessor :rect
  attr_accessor :range
  attr_accessor :easer

  def initialize(rect, range=96, easer=Easer::Linear)
    @range = range
    @easer = easer
    @rect = rect
  end

  def calc(position)
    result = Vector2.new(0, 0)
    return result unless @rect.inside?(position)
    rel = position - @rect.xy
    if rel.x < range
      result.x = 1 - (rel.x / range.to_f)
    elsif rel.x < @rect.width && rel.x >= (@rect.width-@range)
      result.x = -(1 + (rel.x-@rect.width) / range)
    end
    if rel.y < range
      result.y = 1 - (rel.y / range.to_f)
    elsif rel.y < @rect.height && rel.y >= (@rect.height-@range)
      result.y = -(1 + (rel.y-@rect.height) / range)
    end
    result.x = @easer.ease(0, 1, result.x)
    result.y = @easer.ease(0, 1, result.y)
    -result
  end
end
