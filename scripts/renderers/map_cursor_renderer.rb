# Generic Map Cursor renderer
class MapCursorRenderer < Moon::RenderContext
  def initialize_content
    super
    @texture = Game.instance.textures['ui/map_editor_cursor']
    @sprite = Moon::Sprite.new(@texture)
  end

  def render_content(x, y, z, options)
    @sprite.render x, y, z
  end
end
