class EntityPositionAdapter
  def initialize(obj)
    @obj = obj
    @position = Vector3.new(0, 0, 0)
  end

  def position
    pos = @obj[:position]
    @position.x = pos.x
    @position.y = pos.y
    @position
  end
end
