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
    if @tileset_sprite
      pos = [x, y, z] + @position
      @tileset_sprite.render(*pos)
    end
    super x, y, z, options
  end
end

class TilePaletteEditorModel < StateModel
  field :tile_palette, type: ES::DataModel::EditorTilePalette, allow_nil: true, default: nil

  def update_model(delta)
    super(delta)
  end
end

class TilePaletteEditorView < StateView
  def init_view
    super

  end

  def update_view(delta)
    super(delta)
  end
end

class TilePaletteEditorController < StateController
  def init_controller
    super

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
