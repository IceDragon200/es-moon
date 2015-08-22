require 'scripts/renderers/map_renderer'
require 'scripts/renderers/editor_chunk_renderer'

# Extended renderer for rendering EditorMaps with support for borders, labels,
# overlays and underlays
class EditorMapRenderer < MapRenderer
  attr_accessor :show_borders
  attr_accessor :show_labels
  attr_accessor :show_underlay
  attr_accessor :show_overlay

  def initialize_members
    super
    @show_borders = false
    @show_labels = false
    @show_underlay = false
    @show_overlay = false
  end

  def chunk_renderer_class
    EditorChunkRenderer
  end

  def render_show_options
    options = {}
    options[:show_border] = @show_borders unless @show_borders.nil?
    options[:show_label] = @show_labels unless @show_labels.nil?
    options[:show_underlay] = @show_underlay unless @show_underlay.nil?
    options[:show_overlay] = @show_overlay unless @show_overlay.nil?
    options
  end

  def render_content(x, y, z, options)
    super x, y, z, options.merge(render_show_options)
  end
end
