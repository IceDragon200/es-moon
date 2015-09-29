module UI
  class MapEditorLayerView < Moon::RenderContext
    attr_accessor :layer_count

    protected def initialize_members
      super
      @index = -1
      @layer_count = 2
    end

    protected def initialize_content
      super
      @sprite = Moon::Sprite.new(Game.instance.textures['ui/hud_mockup'])
    end

    private def refresh_clip_rect
      rect = Moon::Rect.new(144, 80, 16, 40)
      @sprite.clip_rect = case @index
      when 0
        rect.translatef(1, 0)
      when 1
        rect.translatef(2, 0)
      when 2
        rect.translatef(3, 0)
      else
        rect
      end
    end

    # @return [Integer]
    attr_reader :index

    # @param [Integer] index
    def index=(index)
      @index = index
      refresh_clip_rect
    end

    # @return [Integer]
    def w
      @w ||= @sprite.w * 4
    end

    # @return [Integer]
    def h
      @h ||= @sprite.h
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    protected def render_content(x, y, z)
      @sprite.render x, y, z
    end
  end
end
