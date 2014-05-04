module ES
  module UI
    class SelectionTileRect < RenderContainer

      include Activatable

      attr_accessor :tile_rect
      attr_accessor :color
      attr_accessor :spritesheet

      def initialize
        super
        @active = false
        @tile_rect = Rect.new 0, 0, 0, 0
        @spritesheet = nil
        @color = Color.new 1.0, 1.0, 1.0, 1.0
      end

      def width
        return 0 unless @spritesheet
        @spritesheet.cell_width * @tile_rect.w
      end

      def height
        return 0 unless @spritesheet
        @spritesheet.cell_height * @tile_rect.h
      end

      def render(x, y, z)
        if @spritesheet
          px, py, pz = *(@position + [x, y, z])# + @tile_rect.xyz)
          @tile_rect.h.times do |i|
            @tile_rect.w.times do |j|
              @spritesheet.render px + j * @spritesheet.cell_width,
                                  py + i * @spritesheet.cell_height,
                                  pz,
                                  1, color: @color
            end
          end
        end
        super x, y, z
      end

    end
  end
end