module Renderers
  # Special renderer for locking a cursor sprite to a grid, it takes an index
  # and column count (cols), the cursor is indexed from left to right,
  # top to bottom.
  class GridCursor < Moon::RenderContext
    attr_accessor :index
    attr_accessor :cols

    # @param [Hash] options
    protected def initialize_from_options(options)
      super
      @texture = options.fetch(:texture)
    end

    protected def initialize_members
      super
      @index = 0
      @cols = 0
    end

    protected def initialize_content
      super
      @sprite = Moon::Sprite.new(@texture)
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    def render_content(x, y, z, options)
      return if @cols <= 0
      @sprite.render x + @sprite.w * (@index % @cols),
        y + @sprite.h * (@index / @cols).to_i,
        z
    end
  end
end
