module ES
  module States
    class MapEditor < Map

      def init
        super
        @mouse = Moon::Input::Mouse
        @tile_preview = ES::UI::TilePreview.new
        @tile_preview.map = @map
        @tile_preview.tileset = @tileset
      end

      def update
        super
        tp = screen_pos_to_map_pos(Vector2[@mouse.x, @mouse.y])
        @tile_preview.tile_position.set(tp)
      end

      def render
        super
        @tile_preview.render 0, 0, 0
      end

    end
  end
end