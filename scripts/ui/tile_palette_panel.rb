class TilePalettePanel < Moon::RenderContext
  attr_accessor :cursor_position # Vector3
  attr_reader :tile_palette # EditorTilePalette

  def initialize
    super
    @background = Moon::Sprite.new('resources/ui/grid_32x32_ff777777.png')
    @cursor = Moon::Sprite.new('resources/ui/map_editor_cursor.png')
    @text = Moon::Label.new('', FontCache.font('uni0553', 8))
    @tile_palette = nil

    @text.align = :right
  end

  def tile_palette=(tile_palette)
    @tile_palette = tile_palette
    refresh_tile_palette
  end

  def refresh_tile_palette
    tileset = @tile_palette.tileset
    texture = TextureCache.tileset(tileset.filename)
    @spritesheet = Moon::Spritesheet.new(texture, tileset.cell_w, tileset.cell_h)
  end

  def update(delta)
    super
  end

  def render_content(x, y, z, options)
    if @spritesheet
      px, py, pz = *(@position + [x, y, z])
      cw, ch = @spritesheet.cell_w, @spritesheet.cell_h
      cols = @tile_palette.columns
      rows = (@tile_palette.tiles.size / cols).to_i + [1, @tile_palette.tiles.size % cols].min
      @background.clip_rect = Rect.new(0, 0, cols * cw, rows * ch)

      @background.render(px, py, pz)

      @tile_palette.tiles.each_with_index do |i, index|
        @spritesheet.render(px + cw * (index % cols), py + ch * (index / cols).to_i, pz, i)
      end

      curpos = @cursor_position * [cw, ch, 1] + [px, py, pz]
      txtpos = curpos + [@cursor.w - 8, 0, 0]
      txtpos2 = txtpos + [0, @cursor.h - 12, 0]

      tile_index = (@cursor_position.x + @cursor_position.y * cols).to_i

      @cursor.render(*curpos)
      @text.string = "#{tile_index}"
      @text.render(*txtpos)
      @text.string = "#{@tile_palette.tiles[tile_index]}"
      @text.render(*txtpos2)
    end
    super
  end
end
