module ES
  module UI
    class SelectionTileRect < RenderContainer
      attr_accessor :tile_rect
      attr_accessor :color
      attr_accessor :spritesheet

      def initialize
        super
        @active = false
        @tile_rect = Rect.new 0, 0, 0, 0
        @spritesheet = nil
        @color = Vector4.new 1.0, 1.0, 1.0, 1.0
      end

      def width
        return 0 unless @spritesheet
        @spritesheet.cell_width * @tile_rect.w
      end

      def height
        return 0 unless @spritesheet
        @spritesheet.cell_height * @tile_rect.h
      end

      def render(x=0, y=0, z=0, options={})
        if @spritesheet
          cw, ch = @spritesheet.cell_width, @spritesheet.cell_height
          px, py, pz = *(@position + [x, y, z] + @tile_rect.xyz * [cw, ch, 1])
          render_options = { color: @color }.merge(options)
          @tile_rect.h.times do |i|
            @tile_rect.w.times do |j|
              @spritesheet.render px + j * cw,
                                  py + i * ch,
                                  pz,
                                  1, render_options
            end
          end
        end
        super x, y, z
      end
    end
  end
end
