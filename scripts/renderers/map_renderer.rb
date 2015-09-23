require 'scripts/renderers/chunk_renderer'

# Specialized renderer for rendering EditorMaps
class MapRenderer < Moon::RenderContext
  # @return [Camera3]
  attr_accessor :camera

  private def initialize_members
    super
    @layer_opacity = [1.0, 1.0]
  end

  private def initialize_content
    super
    @tilemap = Moon::Tilemap.new
  end

  # @return [Array<Float>]
  def layer_opacity
    @tilemap.layer_opacity || @layer_opacity
  end

  # @param [Array<Float>] layer_opacity
  def layer_opacity=(layer_opacity)
    @layer_opacity = layer_opacity
    @tilemap.layer_opacity = @layer_opacity
  end

  # @return [Models::Map]
  attr_reader :map

  # @param [Models::Map] map
  def map=(map)
    @map = map
    resize nil, nil
    # clear size, so it can refresh
    if @map
      @tileset = @map.tileset
      @texture = Game.instance.textures[@tileset.filename]
      @tilemap.set data: @map.data.blob,
        layer_opacity: @layer_opacity,
        datasize: @map.data.sizes,
        layer_opacity: @layer_opacity,
        tileset: Moon::Spritesheet.new(@texture, @tileset.cell_w, @tileset.cell_h)

      resize @tilemap.w, @tilemap.h
    end
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
    @tilemap.render x, y, z if @map
  end
end
