module ES
  module UI
    class TitleMenu < RenderContainer

      attr_reader :index

      def initialize
        super
        create_fonts
        @index = 0
        make_list
      end

      def get_item(index)
        @list[index]
      end

      def current_item
        get_item(@index)
      end

      def create_fonts
        @bmpfont_unselected = BitmapFont.new("cga8.png")
        @bmpfont_selected = BitmapFont.new("cga8.png")
        @bmpfont_selected.color = Color.new(0.2000, 0.7098, 0.8980, 1.0000)
      end

      def make_list
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
        px, py, pz = *@position
        @list.each_with_index do |dat, i|
          font = i == @index ? @bmpfont_selected : @bmpfont_unselected
          font.string = dat[:name]
          font.render(px + x, py + y + oy, pz + z)
          oy += font.height
        end
        super x, y, z
      end

    end
  end
end