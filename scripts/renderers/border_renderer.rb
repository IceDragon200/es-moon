module Renderers
  # Generic Renderer object for display a L shaped border
  class Border < Moon::RenderContext
    # @return [Moon::Rect]
    attr_accessor :border_rect
    # @return [Boolean]
    attr_accessor :animate

    protected def initialize_members
      super
      @animate = false
      @amount = 8
      @direction = 1
      @offset = 0
      @speed = 1
      @border_rect = Moon::Rect.new(0, 0, 0, 0)
    end

    protected def initialize_content
      super
      @chunk_borders = ES.game.spritesheets['ui/map_outline_3x3', 32, 32]
    end

    protected def update_content(delta)
      if @animate
        @offset += @amount * delta * @direction * @speed
        if (@direction > 0 && @offset > @amount) ||
          (@direction < 0 && @offset < 0)
          @direction = -@direction
        end
      end
    end

    protected def render_content(x, y, z)
      unless @border_rect.empty?
        w = @border_rect.w - 32
        h = @border_rect.h - 32
        a = @animate ? @offset : 0
        @chunk_borders.render(x - a,     y - a,     z, 0)
        @chunk_borders.render(x + w + a, y - a,     z, 2)
        @chunk_borders.render(x - a,     y + h + a, z, 6)
        @chunk_borders.render(x + w + a, y + h + a, z, 8)
      end
    end
  end
end
