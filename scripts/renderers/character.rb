#
# required CharacterAttribute
# required PositionAttribute
class CharacterRenderer
  attr_accessor :character_attr
  attr_accessor :position_attr

  def initialize
    @spritesheet = nil
    @character_attr = nil
    @position_attr = nil
    @oldfilename = nil
  end

  def check_spritesheet
    if @oldfilename != @character_attr.filename
      @oldfilename = @character_attr.filename
      @spritesheet = ES.cache.tileset(@oldfilename,
                                      @character_attr.cell_width,
                                      @character_attr.cell_height)
    end
  end

  def render(x=0, y=0, z=0, options={})
    return unless @character_attr
    return unless @position_attr
    check_spritesheet
    return unless @spritesheet
    @spritesheet.render(x + @position_attr.x * 32,
                        y + @position_attr.y * 32,
                        z, @character_attr.index,
                        options)
  end
end
