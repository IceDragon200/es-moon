class Caret < RenderContainer
  def initialize
    super
    @index = 0
    @spritesheet = Spritesheet.new("media/ui/caret_8x16_ffffffff.png", 8, 16)
  end

  def width
    @width ||= @spritesheet.cell_width
  end

  def height
    @height ||= @spritesheet.cell_height
  end

  def render(x=0, y=0, z=0, options={})
    px, py, pz = *(@position + [x, y, z])
    @spritesheet.render(px, py, pz, @index, options)
    super
  end
end
