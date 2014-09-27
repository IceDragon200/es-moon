module ES
  module UI
    class SelectionTileRect < Moon::RenderContainer
      attr_accessor :tile_rect
      attr_accessor :color
      attr_accessor :spritesheet

      def initialize(options={})
        super
        @active = false
        @tile_rect = Moon::Rect.new 0, 0, 0, 0
        @spritesheet = nil
        @color = Moon::Vector4.new 1.0, 1.0, 1.0, 1.0
      end

      def width
        return 0 unless @spritesheet
        @spritesheet.cell_width * @tile_rect.w
      end

      def height
        return 0 unless @spritesheet
        @spritesheet.cell_height * @tile_rect.h
      end

      def render_content(x, y, z, options)
        if @spritesheet
          cw, ch = @spritesheet.cell_width, @spritesheet.cell_height
          px, py, pz = *(@tile_rect.xyz * [cw, ch, 1] + [x, y, z])
          render_options = { color: @color }.merge(options)
          @tile_rect.h.times do |i|
            @tile_rect.w.times do |j|
              @spritesheet.render px + j * cw,
                                  py + i * ch,
                                  pz,
                                  6, render_options
            end
          end
        end
        super
      end
    end
  end
end
