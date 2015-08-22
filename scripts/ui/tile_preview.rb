require 'render_primitives/render_context'

module ES
  module UI
    class TilePreview < Moon::RenderContext
      attr_reader :tile_id       # Integer
      # @return [Moon::Spritesheet]
      attr_reader :tileset

      def initialize
        super
        texture = ES.game.texture_cache.block 'e008x008.png'
        @micro_ss = Moon::Spritesheet.new texture, 8, 8
        texture = ES.game.texture_cache.block 'e064x064.png'
        @background_ss = Moon::Spritesheet.new texture, 64, 64

        @text = AnimatedText.new '', ES.game.font_cache.font('uni0553', 16)

        @tile_id = -2
        @old_tile_id = -1
        self.tile_id = -1
        self.tileset = nil
      end

      def tileset=(tileset)
        @tileset = tileset
        resize(nil, nil)
      end

      def tile_id=(tile_id)
        old = @tile_id
        @tile_id = tile_id

        if @tile_id != old
          @old_tile_id = old
          @text.set(string: "Tile #{@tile_id}")
          @text.arm(0.5)
        end
      end

      def w
        @w ||= @background_ss.w
      end

      def h
        @h ||= @background_ss.h
      end

      def update_content(delta)
        @text.update delta
      end

      def render_content(x, y, z, options)
        @background_ss.render x, y, z, 1

        if @tileset
          diff = (@background_ss.cell_size - @tileset.cell_size) / 2

          if @text.done?
            if @tile_id >= 0
              @tileset.render diff.x + x, diff.y + y, z, @tile_id
            end
          else
            r = @text.rate
            if @tile_id >= 0
              @tileset.render diff.x + x, diff.y + y, z, @tile_id, opacity: r
            end
            if @old_tile_id >= 0
              @tileset.render diff.x + x, diff.y + y, z, @old_tile_id, opacity: 1-r
            end
          end

          dx = (@background_ss.w - @text.w) / 2
          @text.render x + dx,
                       diff.y + y + @tileset.h - 4,
                       z
        else
          @micro_ss.render x, y, z, 8
        end
      end
    end
  end
end
