module ES
  module UI
    class MapEditorLayerView < Moon::RenderContext
      attr_accessor :index
      attr_accessor :layer_count

      def initialize
        super
        @layer_ss = Moon::Spritesheet.new("resources/blocks/b016x016.png", 16, 16)
        @layer_count = 2
        @index = -1
      end

      def width
        @width ||= @layer_ss.cell_width * 4
      end

      def height
        @height ||= @layer_ss.cell_height * 2
      end

      def render_content(x, y, z, options)
        w = @layer_ss.cell_width
        h = @layer_ss.cell_height

        @layer_count.times do |i|
          @layer_ss.render x + i * w,
                           y,
                           z,
                           i == @index ? 12 : 1
        end

        @layer_ss.render x,
                         y + h,
                         z,
                         13
        super
      end
    end
  end
end
