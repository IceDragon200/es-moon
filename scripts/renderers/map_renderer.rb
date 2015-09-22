require 'scripts/renderers/chunk_renderer'

# Specialized renderer for rendering EditorMaps
class MapRenderer < Moon::RenderContext
  # @return [Camera3]
  attr_accessor :camera

  private def initialize_content
    super
    @tilemap = Moon::Tilemap.new
  end

  # @return [Array<Float>]
  def layer_opacity
    @tilemap.layer_opacity
  end

  # @param [Array<Float>] layer_opacity
  def layer_opacity=(layer_opacity)
    @tilemap.layer_opacity = layer_opacity
  end

  # @return [Models::Map]
  attr_reader :map

  # @param [Models::Map] map
  def map=(map)
    @map = map
    @tilemap.set data: @map.data.blob, datasize: @map.data.sizes, layer_opacity: @layer_opacity
    # clear size, so it can refresh
    resize @tilemap.w, @tilemap.h
  end

  # Call this to refresh the map renderer
  #
  # @return [self]
  def refresh
    @tilemap.set({ })
    self
  end

  private def apply_position_modifier(*vec3)
    pos = super(*vec3)
    pos -= Moon::Vector3[@camera.view_offset, 0] if @camera
    pos
  end

  private def render_content(x, y, z, options)
    @tilemap.render x, y, z
  end
end
