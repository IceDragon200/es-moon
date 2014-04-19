module ES
  module UI
    class MapEditorHelpPanel < RenderContainer

      def initialize
        super
        @bitmap_font = BitmapFont.new "font_cga8_white.png"
        @bitmap_font.string = "" +
          "'Right Click' to select current tile\n" +
          "'Tab' opens Tile Panel\n" +
          "'Left Click' to place tile, <currently disabled>\n" +
          ""
      end

      def render(x=0, y=0, z=0)
        @bitmap_font.render(*(@position + [x, y, z]))
        super x, y, z
      end

    end
  end
end