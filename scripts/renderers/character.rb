#
# required CharacterAttribute
# required PositionAttribute
class CharacterRenderer
  attr_accessor :character
  attr_accessor :position

  def initialize
    @spritesheet = nil
    @character = nil
    @position = nil
    @oldfilename = nil
  end

  def check_spritesheet
    if @oldfilename != @character.filename
      @oldfilename = @character.filename
      @texture = TextureCache.tileset(@oldfilename)
      @spritesheet = Moon::Spritesheet.new(@texture, @character.cell_width, @character.cell_height)
    end
  end

  def render(x=0, y=0, z=0, options={})
    return unless @character
    return unless @position
    check_spritesheet
    return unless @spritesheet
    @spritesheet.render(x + @position.x * 32,
                        y + @position.y * 32,
                        z, @character.index,
                        options)
  end
end
