class CamCursor

  attr_accessor :position
  attr_accessor :velocity

  def initialize
    @position = Vector3.new
    @velocity = Vector3.new
  end

  def update(delta)
    @position += @velocity * delta
  end

end