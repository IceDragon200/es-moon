class RenderContainer

  @@container_id = 0

  attr_reader :id
  attr_accessor :position

  def initialize
    @position = Vector3.new
    @id = @@container_id += 1
  end

  def x
    @position.x
  end

  def y
    @position.y
  end

  def z
    @position.z
  end

  def width
    0
  end

  def height
    0
  end

  def render(x=0, y=0, z=0)
    self
  end

end