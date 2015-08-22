module ES
  class GridRenderer < Moon::RenderContext
    # @!attribute [r] bounds
    #   @return [Vector2]
    attr_reader :bounds

    def bounds=(bounds)
      @bounds.set(bounds)
      @sprite.clip_rect = Moon::Rect.new(0, 0, @bounds.x, @bounds.y)
    end

    def initialize_members
      super
      @bounds = Moon::Vector2.new
    end

    def initialize_from_options(options)
      super
      @texture = options.fetch(:texture)
    end

    def initialize_content
      super
      @sprite = Moon::Sprite.new(@texture)
      @sprite.clip_rect = Moon::Rect.new(0, 0, 0, 0)
    end

    def render_content(x, y, z, options)
      @sprite.render x, y, z
    end
  end
end
