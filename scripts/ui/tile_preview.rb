module ES
  module UI
    class TilePreview < Moon::RenderContainer
      attr_accessor :tile_id       # Integer
      attr_accessor :tileset       # Spritesheet

      def initialize
        super
        texture = TextureCache.block 'e008x008.png'
        @micro_ss = Moon::Spritesheet.new texture, 8, 8
        texture = TextureCache.block 'e064x064.png'
        @background_ss = Moon::Spritesheet.new texture, 64, 64

        @text = Moon::Text.new '', FontCache.font('uni0553', 16)

        @tileset = nil
        @tile_id = -1
      end

      def w
        @background_ss.cell_w
      end

      def h
        @background_ss.cell_h
      end

      def render_content(x, y, z, options)
        @background_ss.render x, y, z, 1

        if @tileset
          diff = (@background_ss.cell_size - @tileset.cell_size) / 2

          if @tile_id >= 0
            @tileset.render diff.x + x, diff.y + y, z, @tile_id
          end

          @text.string = @tile_id.to_s
          @text.render diff.x + x,
                       diff.y + y + @tileset.cell_h,
                       z
        else
          @micro_ss.render x, y, z, 8
        end
        super
      end
    end
  end
end
