module ES
  module UI
    class MapEditorHelpPanel < RenderContainer
      def initialize
        super
        @text = Text.new "", ES.cache.font("uni0553", 16)
        @text.string = "" +
          "'Right Click' to erase current tile\n" +
          "'Middle Click' to select current tile\n" +
          "'Left Click' to place tile\n" +
          "'Tab' opens Tile Panel\n" +
          "'1' selects the base layer for editing\n" +
          "'2' selects the detail layer for editing\n" +
          "'~' deactivates layer editing\n" +
          "'+' increase Zoom Level\n" +
          "'-' descrease Zoom Level\n" +
          "'0' reset Zoom Level\n" +
          ""
      end

      def width
        @text.width
      end

      def height
        @text.height
      end

      def render(x=0, y=0, z=0)
        @text.render(*(@position + [x, y, z]), outline: 2)
        super x, y, z
      end
    end
  end
end
