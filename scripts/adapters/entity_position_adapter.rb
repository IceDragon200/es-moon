class EntityPositionAdapter
  def initialize(obj)
    @obj = obj
    @position = Moon::Vector3.new(0, 0, 0)
  end

  def position
    pos = @obj[:transform].position
    @position.x = pos.x
    @position.y = pos.y
    @position.z = pos.z
    @position
  end
end
