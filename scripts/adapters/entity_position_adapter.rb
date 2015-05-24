class EntityPositionAdapter
  def initialize(obj)
    @obj = obj
    @position = Moon::Vector2.new(0, 0)
  end

  def position
    p = @obj[:transform].position
    @position.set p.x, p.y
    @position
  end
end
