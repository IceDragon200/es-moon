module ES
  module UI
    class MapEditorLayerView < RenderContainer
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

      def render(x=0, y=0, z=0)
        px, py, pz = *(@position + [x, y, z])
        w = @layer_ss.cell_width
        h = @layer_ss.cell_height

        @layer_count.times do |i|
          @layer_ss.render px + i * w,
                           py,
                           pz,
                           i == @index ? 12 : 1
        end

        @layer_ss.render px,
                         py + h,
                         pz,
                         13
        super
      end
    end
  end
end
