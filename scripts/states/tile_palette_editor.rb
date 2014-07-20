class TilePalettePanel < RenderContainer
  attr_reader :tile_palette # EditorTilePalette

  def initialize
    super
    @tile_palette = nil
  end

  def tile_palette=(tile_palette)
    @tile_palette = tile_palette
    refresh_tile_palette
  end

  def refresh_tile_palette
    #
  end

  def update(delta)
    super delta
  end

  def render(x=0, y=0, z=0, options={})
    super
  end
end

class TilesetPanel < RenderContainer
  attr_reader :tileset # Tileset

  def initialize
    super
    @tileset = nil
  end

  def tileset=(tileset)
    @tileset = tileset
    refresh_tileset
  end

  def refresh_tileset
    if @tileset
      @tileset_sprite = Sprite.new(@tileset.filename)
    else
      @tileset_sprite = nil
    end
  end

  def update(delta)
    super delta
  end

  def render(x=0, y=0, z=0, options={})
    super
  end
end

module ES
  module States
    class TilePaletteEditor < Base
      def init
        super
      end

      def update(delta)
        super(delta)
      end

      def render
        super
      end
    end
  end
end
