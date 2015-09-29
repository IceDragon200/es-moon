module Renderers
  # Generic Map Cursor renderer
  class MapCursor < Moon::RenderContext
    def initialize_content
      super
      @texture = Game.instance.textures['ui/map_editor_cursor']
      @sprite = Moon::Sprite.new(@texture)
    end

    def render_content(x, y, z)
      @sprite.render x, y, z
    end
  end
end
