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
