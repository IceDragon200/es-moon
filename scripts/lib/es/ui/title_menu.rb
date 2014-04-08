module ES
  module UI
    class TitleMenu < RenderContainer

      def initialize
        super
        @bmpfont_unselected = BitmapFont.new("font_cga8_white.png")
        @bmpfont_selected = BitmapFont.new("font_cga8_droid_blue.png")
        @index = 0
        @list = [
          { id: :newgame, name: "New Game" },
          #{ id: :continue, name: "Continue" },
          { id: :quit, name: "Quit" }
        ]
      end

      def index=(new_index)
        @index = new_index % [@list.size, 1].max
      end

      def render(x, y, z)
        oy = 0
        @list.each_with_index do |dat, i|
          font = i == @index ? @bmpfont_selected : @bmpfont_unselected
          font.set_string(dat[:name]).render(x, y + oy, z)
          oy += font.height
        end
      end

    end
  end
end