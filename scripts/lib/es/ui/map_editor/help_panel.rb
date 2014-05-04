module ES
  module UI
    class MapEditorHelpPanel < RenderContainer

      def initialize
        super
        @text = Text.new "", Cache.font("uni0553", 16)
        @text.string = "" +
          "'Right Click' to erase current tile\n" +
          "'Middle Click' to select current tile\n" +
          "'Left Click' to place tile\n" +
          "'Tab' opens Tile Panel\n" +
          ""
      end

      def width
        @text.width
      end

      def height
        @text.height
      end

      def render(x=0, y=0, z=0)
        @text.render(*(@position + [x, y, z]))
        super x, y, z
      end

    end
  end
end