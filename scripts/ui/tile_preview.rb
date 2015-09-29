require 'render_primitives/render_context'

module UI
  class TilePreview < Moon::RenderContext
    attr_reader :tile_id       # Integer
    # @return [Moon::Spritesheet]
    attr_reader :spritesheet

    protected def initialize_content
      super
      @micro_ss = Game.instance.spritesheets['ui/passage_icons_mini', 8, 8]

      texture = Game.instance.textures['ui/tile_preview_background']
      @background = Moon::Sprite.new texture

      @text = AnimatedText.new '', Game.instance.fonts['system.16']

      @tile_id = -2
      @old_tile_id = -1
      self.tile_id = -1
      self.spritesheet = nil
    end

    # @param [Moon::Spritesheet] spritesheet
    def spritesheet=(spritesheet)
      @spritesheet = spritesheet
      resize(nil, nil)
    end

    # @param [Integer] tile_id
    def tile_id=(tile_id)
      old = @tile_id
      @tile_id = tile_id

      if @tile_id != old
        @old_tile_id = old
        @text.set(string: "Tile #{@tile_id}")
        @text.arm(0.5)
      end
    end

    # @return [Integer]
    def w
      @w ||= @background.w
    end

    # @return [Integer]
    def h
      @h ||= @background.h
    end

    # @param [Float] delta
    def update_content(delta)
      @text.update delta
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    def render_content(x, y, z)
      @background.render x, y, z

      if @spritesheet
        diff = (@background.cell_size - @spritesheet.cell_size) / 2

        if @text.done?
          if @tile_id >= 0
            @spritesheet.render diff.x + x, diff.y + y, z, @tile_id
          end
        else
          r = @text.rate
          if @tile_id >= 0
            @spritesheet.render diff.x + x, diff.y + y, z, @tile_id, opacity: r
          end
          if @old_tile_id >= 0
            @spritesheet.render diff.x + x, diff.y + y, z, @old_tile_id, opacity: 1-r
          end
        end

        dx = (@background.w - @text.w) / 2
        @text.render x + dx,
                     diff.y + y + @spritesheet.h - 4,
                     z
      else
        @micro_ss.render x, y, z, 8
      end
    end
  end
end
