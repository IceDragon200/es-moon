module ES
  module UI
    class TilePreview < RenderContainer

      attr_accessor :tile_id       # Integer
      attr_accessor :tileset       # Spritesheet

      def initialize
        super
        @cursor_ss = Moon::Spritesheet.new "resources/blocks/e064x064.png",
                                           64, 64

        @bitmap_font = BitmapFont.new "font_cga8_white.png"

        @tileset = nil
        @tile_id = -1
      end

      def width
        @cursor_ss.cell_width
      end

      def height
        @cursor_ss.cell_height
      end

      def render(x=0, y=0, z=0)
        if @tileset && @tile_id >= 0
          px, py, pz = *(@position + [x, y, z])
          @cursor_ss.render px, py, pz, 1

          diff = (@cursor_ss.cell_size - @tileset.cell_size) / 2
          @tileset.render diff.x + px, diff.y + py, pz, @tile_id

          @bitmap_font.string = @tile_id
          @bitmap_font.render diff.x + px,
                              diff.y + py + @tileset.cell_height,
                              pz
        end
        super x, y, z
      end

    end
  end
end