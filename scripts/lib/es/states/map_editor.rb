module ES
  module States
    class MapEditor < Map

      def init
        super
        @mouse = Moon::Input::Mouse
        @tile_preview = ES::UI::TilePreview.new
        @tile_preview.map = @map
        @tile_preview.tileset = @tileset

        @cursor_position = Vector2.new

        @cursor_ss = Moon::Spritesheet.new("resources/blocks/e032x032.png", 32, 32)
      end

      def update
        tp = screen_pos_to_map_pos(Vector2[@mouse.x, @mouse.y])
        @cursor_position.set((tp.floor * 32) - @camera.view_xy)
        @tile_preview.tile_position.set(tp)
        super
      end

      def render
        super
        @tile_preview.render 0, 8, 0

        @cursor_ss.render(*@cursor_position, 0, 1)
      end

    end
  end
end