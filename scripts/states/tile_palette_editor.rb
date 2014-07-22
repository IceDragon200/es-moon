class TilePalettePanel < RenderContainer
  attr_accessor :cursor_position # Vector3
  attr_reader :tile_palette # EditorTilePalette

  def initialize
    super
    @background = Sprite.new("media/ui/grid_32x32_ff777777.png")
    @cursor = Sprite.new("media/ui/map_editor_cursor.png")
    @tile_palette = nil
  end

  def tile_palette=(tile_palette)
    @tile_palette = tile_palette
    refresh_tile_palette
  end

  def refresh_tile_palette
    tileset = @tile_palette.tileset
    @spritesheet = ES.cache.tileset(tileset.filename,
                                    tileset.cell_width, tileset.cell_height)
  end

  def update(delta)
    super delta
  end

  def render(x=0, y=0, z=0, options={})
    if @spritesheet
      px, py, pz = *(@position + [x, y, z])
      cw, ch = @spritesheet.cell_width, @spritesheet.cell_height
      cols = @tile_palette.columns
      rows = @tile_palette.tiles.size / cols + [1, @tile_palette.tiles.size % cols].min
      @background.clip_rect = Rect.new(0, 0, cols * cw, rows * ch)

      @background.render(px, py, pz)

      @tile_palette.tiles.each do |i|
        @spritesheet.render(px + cw * (i % cols), py + ch * (i / cols), pz, i)
      end

      @cursor.render(*(@cursor_position * [cw, ch, 1] + [px, py, pz]))
    end
    super
  end
end

class TilesetPanel < RenderContainer
  attr_accessor :cursor_position # Vector3
  attr_reader :tileset # Tileset

  def initialize
    super
    @background = Sprite.new("media/ui/grid_32x32_ff777777.png")
    @cursor = Sprite.new("media/ui/map_editor_cursor.png")
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
    px, py, pz = *(@position + [x, y, z])
    if @tileset_sprite
      @background.clip_rect = Rect.new(0, 0, @tileset_sprite.width, @tileset_sprite.height)
      @background.render(px, py, pz)
      @tileset_sprite.render(px, py, pz)
      @cursor.render(*(@cursor_position * [@tileset.cell_width, @tileset.cell_height, 1] + [px, py, pz]))
    end
    super
  end
end

class TileCursor < ::DataModel::Metal
  field :position, type: Vector3, default: proc{|t|t.new}
end

class TilePaletteEditorModel < StateModel
  field :pallete_cursor, type: TileCursor, default: proc{|t|t.new}
  field :tileset_cursor, type: TileCursor, default: proc{|t|t.new}
  field :tile_palette, type: ES::DataModel::EditorTilePalette, allow_nil: true, default: nil

  def update_model(delta)
    super(delta)
  end
end

class TilePaletteEditorView < StateView
  def init_view
    super
    @tile_palette_panel = TilePalettePanel.new
    @tileset_panel = TilesetPanel.new

    @tileset_panel.position.set(0, 128, 0)

    add(@tile_palette_panel)
    add(@tileset_panel)
  end

  def refresh
    @tile_palette_panel.tile_palette = @model.tile_palette
    @tileset_panel.tileset = @model.tile_palette.tileset
  end

  def update_view(delta)
    @tile_palette_panel.cursor_position = @model.pallete_cursor.position
    @tileset_panel.cursor_position = @model.tileset_cursor.position
    super(delta)
  end
end

class TilePaletteEditorController < StateController
  def init_controller
    super

  end

  def tileset_cursor_to_tile_id

  end

  def move_tileset_cursor(x, y)
    @model.tileset_cursor.position += [x, y, 0]
    @model.tileset_cursor.position.x = 0 if @model.tileset_cursor.position.x < 0
    @model.tileset_cursor.position.y = 0 if @model.tileset_cursor.position.y < 0
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
    super(delta)
  end
end

module ES
  module States
    class TilePaletteEditor < Base
      def init
        super
        @model = TilePaletteEditorModel.new
        @view = TilePaletteEditorView.new(@model)
        @controller = TilePaletteEditorController.new(@model, @view)

        @model.tile_palette = cvar["tile_palette"]
        @view.refresh

        register_input
      end

      def register_input
        @input.on :press, :h do
          @controller.move_tileset_cursor(-1, 0)
        end

        @input.on :press, :j do
          @controller.move_tileset_cursor(0, 1)
        end

        @input.on :press, :k do
          @controller.move_tileset_cursor(0, -1)
        end

        @input.on :press, :l do
          @controller.move_tileset_cursor(1, 0)
        end

        @input.on :press, :z do
          @controller.add_to_palette
        end

        @input.on :press, :x do
          @controller.remove_from_palette
        end

        @input.on :press, :c do
          @controller.jump_to_tile
        end
      end

      def update(delta)
        @controller.update(delta)
        super(delta)
      end

      def render
        @view.render
        super
      end
    end
  end
end
