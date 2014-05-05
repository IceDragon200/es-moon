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
        font = Cache.font "uni0553", 16
        @text_unselected = Text.new "", font
        @text_selected = Text.new "", font
        @text_selected.color = Vector4.new(0.2000, 0.7098, 0.8980, 1.0000)
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
        pos = @position + [x, y, z]
        @list.each_with_index do |dat, i|
          text = i == @index ? @text_selected : @text_unselected
          text.string = dat[:name]
          text.render(pos.x, pos.y + oy, pos.z)
          oy += text.height
        end
        super x, y, z
      end

    end
  end
end