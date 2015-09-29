require 'scripts/renderers/map_renderer'
require 'scripts/renderers/border_renderer'
require 'scripts/renderers/grid_renderer'

module Renderers
  # Extended renderer for rendering EditorMaps with support for borders, labels,
  # overlays and underlays
  class EditorMap < Map
    # @return [Boolean]
    attr_accessor :show_borders

    # @return [Boolean]
    attr_accessor :show_labels

    # @return [Boolean]
    attr_accessor :show_underlay

    # @return [Boolean]
    attr_accessor :show_overlay

    protected def initialize_members
      super
      @show_borders = false
      @show_labels = false
      @show_underlay = false
      @show_overlay = false
      @border_rect = Moon::Rect.new
    end

    protected def initialize_content
      super
      textures = Game.instance.textures
      @border_renderer = Renderers::Border.new
      @overlay_grid_renderer = Renderers::Grid.new texture: textures['ui/map_editor_overlay_grid']
      @underlay_grid_renderer = Renderers::Grid.new texture: textures['ui/map_editor_underlay_grid']
      @label_color = Moon::Vector4.new(1, 1, 1, 1)
      @label_text = Moon::Text.new Game.instance.fonts['system'], '',
        color: @label_color
    end

    private def render_grid(x, y, z)
    end

    private def render_grid_underlay(x, y, z)
      @underlay_grid_renderer.bounds = @bounds
      @underlay_grid_renderer.render x, y, z
    end

    private def render_grid_overlay(x, y, z)
      @overlay_grid_renderer.bounds = @bounds
      @overlay_grid_renderer.render x, y, z
    end

    private def render_borders(x, y, z)
      @border_renderer.border_rect = @border_rect.set(0, 0, *@bounds)
      @border_renderer.render x, y, z
    end

    private def render_label(x, y, z)
      oy = @label_text.font.size + 8
      r, b = x + @map.w * 32, y + @map.h * 32

      @label_text.color = @label_color

      @label_text.string = @map.name
      @label_text.render(x, y - oy, z)

      @label_text.string = "#{@map.w}x#{@map.h}"
      @label_text.render(r, b, z)
    end

    protected def render_content(x, y, z)
      @bounds = @map.bounds.resolution * 32
      render_grid_underlay x, y, z if @show_underlay
      super x, y, z
      render_grid_overlay x, y, z if @show_overlay
      render_borders x, y, z if @show_borders
      render_label x, y, z if @show_labels
    end
  end
end
