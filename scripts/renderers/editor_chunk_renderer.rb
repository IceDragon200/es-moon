require 'scripts/renderers/chunk_renderer'
require 'scripts/renderers/grid_renderer'
require 'scripts/renderers/border_renderer'

# Specialized renderer for rendering Map Editor Chunks with grid and border
# additions
class EditorChunkRenderer < ChunkRenderer
  attr_accessor :show_border
  attr_accessor :show_label
  attr_accessor :show_underlay
  attr_accessor :show_overlay
  attr_accessor :border_renderer

  def initialize_members
    super
    @show_border = false
    @show_label = false
    @show_underlay = false
    @show_overlay = false
  end

  def initialize_content
    super
    @grid_underlay = ES::GridRenderer.new texture: ES.game.texture_cache.ui('grid_32x32_ff777777.png')
    @grid_overlay  = ES::GridRenderer.new texture: ES.game.texture_cache.ui('grid_32x32_ffffffff.png')

    @border_renderer = BorderRenderer.new

    @label_color = Moon::Vector4.new(1, 1, 1, 1)
    font = ES.game.font_cache.font('uni0553', 16)
    @label_text = Moon::Text.new font, ''
  end

  def update_content(delta)
    super
    @border_renderer.update delta
  end

  def render_label(x, y, z, options)
    oy = @label_text.font.size + 8
    r, b = x + @chunk.w * 32, y + @chunk.h * 32

    @label_text.color = @label_color

    @label_text.string = @chunk.name
    @label_text.render(x, y - oy, z)

    @label_text.string = "#{@chunk.w}x#{@chunk.h}"
    @label_text.render(r, b, z)
  end

  def render_content(x, y, z, options)
    return unless @chunk

    bounds = @chunk.bounds.resolution * 32

    if options.fetch(:show_underlay, @show_underlay)
      @grid_underlay.bounds = bounds
      @grid_underlay.render(x, y, z)
    end

    super

    if options.fetch(:show_border, @show_border)
      @border_renderer.border_rect = Moon::Rect.new(0, 0, *bounds)
      @border_renderer.render(x, y, z + 0.2, options)
    end

    if options.fetch(:show_overlay, @show_overlay)
      @grid_overlay.bounds = bounds
      @grid_overlay.render(x, y, z)
    end

    render_label(x, y, z, options) if options.fetch(:show_label, @show_label)
  end
end
