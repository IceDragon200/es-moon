module Renderers
  class Grid < Moon::RenderContext
    # @!attribute [r] bounds
    #   @return [Vector2]
    attr_reader :bounds

    # Sets the grid bound size
    #
    # @param [Vector2] bounds
    def bounds=(bounds)
      @bounds.set(bounds)
      @sprite.clip_rect = Moon::Rect.new(0, 0, @bounds.x, @bounds.y)
    end

    protected def initialize_members
      super
      @bounds = Moon::Vector2.new
    end

    protected def initialize_from_options(options)
      super
      @texture = options.fetch(:texture)
    end

    protected def initialize_content
      super
      @sprite = Moon::Sprite.new(@texture)
      @sprite.clip_rect = Moon::Rect.new(0, 0, 0, 0)
    end

    protected def render_content(x, y, z)
      @sprite.render x, y, z
    end
  end
end
