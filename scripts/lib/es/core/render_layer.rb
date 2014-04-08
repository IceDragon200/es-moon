class RenderContainer

  @@container_id = 0

  attr_reader :id

  attr_accessor :x
  attr_accessor :y
  attr_accessor :z

  def initialize
    @x = 0
    @y = 0
    @z = 0
    @id = @@container_id += 1
  end

  def render(x=0, y=0, z=0)

  end

end

class RenderLayer < RenderContainer

  def initialize
    super
    @elements = []
  end

  def width
    x = 0
    x2 = 0
    @elements.each do |e|
      ex = e.x
      ex2 = ex + e.width
      x = ex if ex < x
      x2 = ex2 if ex2 > x2
    end
    x2 - x
  end

  def height
    y = 0
    y2 = 0
    @elements.each do |e|
      ey = e.y
      ey2 = ey + e.height
      y = ey if ey < y
      y2 = ey2 if ey2 > y2
    end
    y2 - y
  end

  def each(&block)
    @elements.each(&block)
  end

  def add(element)
    @elements.push(element)
  end

  def remove(element)
    @elements.delete(element)
  end

  def render(x=0, y=0, z=0)
    @elements.each { |e| e.render(@x + x, @y + y, @z + z) }
  end

end