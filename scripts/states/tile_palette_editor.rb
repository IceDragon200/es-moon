class TilePalettePanel < Moon::RenderContainer
  attr_accessor :cursor_position # Vector3
  attr_reader :tile_palette # EditorTilePalette

  def initialize
    super
    @background = Moon::Sprite.new('resources/ui/grid_32x32_ff777777.png')
    @cursor = Moon::Sprite.new('resources/ui/map_editor_cursor.png')
    @text = Moon::Text.new('', FontCache.font('uni0553', 8))
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

  def render(x=0, y=0, z=0, options={})
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

class TilesetPanel < Moon::RenderContainer
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

  def render(x=0, y=0, z=0, options={})
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

class TilePaletteInfoPanel < Moon::RenderContainer
  attr_accessor :tile_palette

  def initialize
    super
    @text = Moon::Text.new('', FontCache.font('uni0553', 16))
    @tile_palette = nil
    add(@text)
  end

  def update_content(delta)
    if @tile_palette
      @text.string = "columns: #{@tile_palette.columns}\n" +
                     "rows: #{@tile_palette.rows}\n" +
                     "\n" +
                     "\n"
    else
      @text.string = ''
    end
    super
  end
end

class TileCursor < Moon::DataModel::Metal
  field :position, type: Moon::Vector3, default: proc{|t|t.new}
end

class TilePaletteEditorModel < State::ModelBase
  field :palette_cursor, type: TileCursor, default: proc{|t|t.new}
  field :tileset_cursor, type: TileCursor, default: proc{|t|t.new}
  field :tile_palette, type: ES::EditorTilePalette, allow_nil: true, default: nil
  field :tileset,      type: ES::Tileset, allow_nil: true, default: nil
end

class TilePaletteEditorView < State::ViewBase
  def init_view
    super
    @tile_palette_panel = TilePalettePanel.new
    @tileset_panel = TilesetPanel.new
    @info_panel = TilePaletteInfoPanel.new

    @tileset_panel.position.set(0, 128, 0)
    @info_panel.position.set(engine.screen.w - 128, 0, 0)

    add(@tile_palette_panel)
    add(@tileset_panel)
    add(@info_panel)
  end

  def refresh
    @tile_palette_panel.tile_palette = @model.tile_palette
    @info_panel.tile_palette = @tile_palette_panel.tile_palette
    @tileset_panel.tileset = @model.tile_palette.tileset
  end

  def update_view(delta)
    @tile_palette_panel.cursor_position = @model.palette_cursor.position
    @tileset_panel.cursor_position = @model.tileset_cursor.position
    super(delta)
  end
end

class TilePaletteEditorController < State::ControllerBase
  def init_controller
    super

  end

  def tileset_cursor_to_tile_id
    (@model.tileset_cursor.position.x + @model.tileset_cursor.position.y * @model.tileset.columns).to_i
  end

  def move_tileset_cursor(x, y)
    @model.tileset_cursor.position += [x, y, 0]
    @model.tileset_cursor.position.x = [[@model.tileset_cursor.position.x, 0].max, @model.tileset.columns-1].min
    @model.tileset_cursor.position.y = 0 if @model.tileset_cursor.position.y < 0
  end

  def move_palette_cursor(x, y)
    @model.palette_cursor.position += [x, y, 0]
    @model.palette_cursor.position.x = [[@model.palette_cursor.position.x, 0].max, @model.tile_palette.columns-1].min
    @model.palette_cursor.position.y = [[@model.palette_cursor.position.y, 0].max, @model.tile_palette.rows-1].min
  end

  def add_to_palette
    @model.tile_palette.tiles << tileset_cursor_to_tile_id
  end

  def remove_from_palette
    @model.tile_palette.tiles.delete(tileset_cursor_to_tile_id)
  end

  def jump_to_tile
  end

  def update_controller(delta)
    super
  end
end

module States
  class TilePaletteEditor < Base
    def init
      super
      @model = TilePaletteEditorModel.new
      @view = TilePaletteEditorView.new(@model)
      @controller = TilePaletteEditorController.new(@model, @view)

      @model.tile_palette = cvar['tile_palette']
      @model.tileset = @model.tile_palette.tileset
      @view.refresh

      register_input
    end

    def register_input
      # move tileset cursor
      input.on :press, :h do
        @controller.move_tileset_cursor(-1, 0)
      end

      input.on :press, :j do
        @controller.move_tileset_cursor(0, 1)
      end

      input.on :press, :k do
        @controller.move_tileset_cursor(0, -1)
      end

      input.on :press, :l do
        @controller.move_tileset_cursor(1, 0)
      end

      input.on :press, :z do
        @controller.add_to_palette
      end

      input.on :press, :x do
        @controller.remove_from_palette
      end

      input.on :press, :c do
        @controller.jump_to_tile
      end

      # move palette cursor
      input.on :press, :left do
        @controller.move_palette_cursor(-1, 0)
      end

      input.on :press, :down do
        @controller.move_palette_cursor(0, 1)
      end

      input.on :press, :up do
        @controller.move_palette_cursor(0, -1)
      end

      input.on :press, :right do
        @controller.move_palette_cursor(1, 0)
      end
    end

    def update(delta)
      @controller.update(delta)
      super
    end

    def render
      @view.render
      super
    end
  end
end
