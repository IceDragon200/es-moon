module ES
  module UI
    class TilePreview < RenderContainer

      attr_accessor :tile_id       # Integer
      attr_accessor :tileset       # Spritesheet

      def initialize
        super
        @cursor_ss = ES.cache.block "e064x064.png", 64, 64

        @text = Text.new "", ES.cache.font("uni0553", 16)

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
        if @tileset
          px, py, pz = *(@position + [x, y, z])
          @cursor_ss.render px, py, pz, 1

          diff = (@cursor_ss.cell_size - @tileset.cell_size) / 2

          if @tile_id >= 0
            @tileset.render diff.x + px, diff.y + py, pz, @tile_id
          end

          @text.string = @tile_id
          @text.render diff.x + px,
                       diff.y + py + @tileset.cell_height,
                       pz
        end
        super x, y, z
      end

    end
  end
end
