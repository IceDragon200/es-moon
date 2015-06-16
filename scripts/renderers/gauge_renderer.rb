class GaugeRenderer < Moon::RenderContext
  attr_reader :rate
  attr_reader :bar_index

  def initialize_members
    super
    @rate = 1.0
    @bar_index = 1
  end

  # @param [Moon::Texture] texture
  # @param [Integer] cw  cell width
  # @param [Integer] ch  cell height
  def set_texture(texture, cw, ch)
    @gauge_texture = texture
    @base_sprite = Moon::Sprite.new @gauge_texture
    @base_sprite.clip_rect = Moon::Rect.new 0, 0, cw, ch
    @bar_sprite = Moon::Sprite.new @gauge_texture
    on_bar_index_changed

    @base_sprite.ox = @base_sprite.w / 2
    @base_sprite.oy = @base_sprite.h
    @bar_sprite.ox = @bar_sprite.w / 2
    @bar_sprite.oy = @bar_sprite.h

    self.w = @base_sprite.w
    self.h = @base_sprite.h

    on_rate_changed
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] z
  # @param [Hash] options
  def render_content(x, y, z, options)
    if @base_sprite
      @base_sprite.render x - @base_sprite.ox, y - @base_sprite.oy, z
    end
    if @bar_sprite
      @bar_sprite.render x - @bar_sprite.ox, y - @bar_sprite.oy, z
    end
  end

  def on_bar_index_changed
    cw, ch = @base_sprite.w, @base_sprite.h
    @bar_sprite.clip_rect = Moon::Rect.new 0, @bar_index * ch, cw, ch
  end

  def on_rate_changed
    return unless @bar_sprite
    rect = @bar_sprite.clip_rect.dup
    rect.w = @gauge_texture.w * @rate
    @bar_sprite.clip_rect = rect
  end

  # @param [Float] rate
  def rate=(rate)
    @rate = [[rate, 1.0].min, 0.0].max
    on_rate_changed
  end

  # @param [Integer] index
  def bar_index=(index)
    @bar_index = index
    on_bar_index_changed
  end
end
