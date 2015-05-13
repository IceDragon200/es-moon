module ES
  module UI
    class MapEditorLayerView < Moon::RenderContext
      attr_accessor :index
      attr_accessor :layer_count

      def initialize
        super
        @layer_ss = Moon::Spritesheet.new('resources/blocks/b016x016.png', 16, 16)
        @layer_count = 2
        @index = -1
      end

      def w
        @w ||= @layer_ss.cell_w * 4
      end

      def h
        @h ||= @layer_ss.cell_h * 2
      end

      def render_content(x, y, z, options)
        cw = @layer_ss.cell_w
        ch = @layer_ss.cell_h

        @layer_count.times do |i|
          @layer_ss.render x + i * cw,
                           y,
                           z,
                           i == @index ? 12 : 1
        end

        @layer_ss.render x,
                         y + ch,
                         z,
                         13
        super
      end
    end
  end
end
