class TilesetPanel < Moon::RenderContext
  attr_accessor :cursor_position # Vector3
  attr_reader :tileset # Tileset

  def initialize
    super
    @background = Sprite.new('media/ui/grid_32x32_ff777777.png')
    @cursor = Sprite.new('media/ui/map_editor_cursor.png')
    @tileset = nil
  end

  def tileset=(tileset)
    @tileset = tileset
    refresh_tileset
  end

  def refresh_tileset
    if @tileset
      @tileset_sprite = Sprite.new("media/tilesets/#{@tileset.filename}")
    else
      @tileset_sprite = nil
    end
  end

  def update(delta)
    super delta
  end

  def render_content(x, y, z, options)
    if @tileset_sprite
      px, py, pz = *(@position + [x, y, z])
      cw, ch = @tileset.cell_w, @tileset.cell_h
      page_y = @cursor_position.y * ch

      @tileset_sprite.clip_rect = Rect.new(0, page_y, @tileset_sprite.texture.w, screen.h - @position.y)
      @background.clip_rect = Rect.new(0, @tileset_sprite.clip_rect.y%ch, @tileset_sprite.w, @tileset_sprite.h)
      @background.render(px, py, pz)
      @tileset_sprite.render(px, py, pz)
      @cursor.render(*(@cursor_position * [cw, ch, 1] + [px, py-page_y, pz]))
    end
    super
  end
end
