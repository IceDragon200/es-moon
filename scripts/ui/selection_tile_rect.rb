module UI
  # A special renderer for tile selection rects, appears as multiple
  class SelectionTileRect < Moon::RenderContext
    # @return [Moon::Rect]
    attr_accessor :tile_rect

    # @return [Moon::Vector3]
    attr_reader :cell_size

    protected def initialize_members
      super
      @active = false
      @tile_rect = Moon::Rect.new(0, 0, 0, 0)
      @cell_size = Moon::Vector3.new(0, 0, 0)
      @color = Moon::Vector4.new(1.0, 1.0, 1.0, 1.0)
    end

    protected def initialize_content
      super
      @sprite = nil
    end

    private def refresh_sprite
      if @sprite
        @cell_size.set @sprite.w, @sprite.h, 1
      else
        @cell_size.set 1, 1, 1
      end
    end

    attr_reader :sprite
    # @param [Moon::Sprite] sprite
    def sprite=(sprite)
      @sprite = sprite
      refresh_sprite
    end

    # Total width of the selection rect
    #
    # @return [Integer]
    def w
      return 0 unless @sprite
      @sprite.w * @tile_rect.w
    end

    # Total height of the selection rect
    #
    # @return [Integer]
    def h
      return 0 unless @sprite
      @sprite.h * @tile_rect.h
    end

    # Color
    #
    # @return [Moon::Vector4]
    def color
      @sprite.color
    end

    # @param [Moon::Vector4] color
    def color=(color)
      @sprite.color = color
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    def render_content(x, y, z, options)
      return unless @sprite
      cw, ch = @cell_size.x, @cell_size.y
      px, py, pz = *((@cell_size * [@tile_rect.x, @tile_rect.y, 0]) + [x, y, z])
      @tile_rect.h.times do |i|
        row = py + i * ch
        @tile_rect.w.times do |j|
          @sprite.render px + j * cw, row, pz
        end
      end
    end
  end
end
