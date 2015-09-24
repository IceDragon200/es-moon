require 'std/mixins/transition_host'
require 'scripts/ui/selection_tile_rect'
require 'scripts/renderers/editor_map_renderer'
require 'scripts/renderers/map_cursor_renderer'

class MapEditorMapView < State::ViewBase
  def start
    super
    @scheduler = Moon::Scheduler.new
    refresh_tilemaps
  end

  def initialize_view
    super
    @tileselection_rect = UI::SelectionTileRect.new
    @tileselection_rect.tile_rect = @model.selection_rect
    @map_renderer = EditorMapRenderer.new
    @map_cursor = MapCursorRenderer.new
    texture = game.textures['ui/selection_tile']
    sprite = Moon::Sprite.new texture
    color = game.database['palette']['system/selection']
    @tileselection_rect.sprite = sprite
    @tileselection_rect.color = color

    add @map_renderer
    add @map_cursor
  end

  def refresh_layer_opacity
    src = @map_renderer.layer_opacity.dup
    dest = @model.layer_opacity.dup
    @scheduler.transition 0, 1, 0.25 do |d|
      ops = @map_renderer.layer_opacity.dup
      dest.each_with_index do |n, i|
        ops[i] = src[i].lerp(n, d)
      end
      @map_renderer.layer_opacity = ops
    end
  end

  def refresh_tilemaps
    @map_renderer.map = @model.map
    refresh_layer_opacity
  end

  def refresh_grid
    @map_renderer.show_underlay = @model.show_grid
  end

  def update_content(delta)
    show_labels = @model.show_map_label
    campos = -@model.camera.view_offset.floor
    pos = @model.map_cursor.position * @model.camera.tilesize + campos
    @map_cursor.position.set pos.x, pos.y, 0
    @map_renderer.show_borders = show_labels
    @map_renderer.show_labels = show_labels
    refresh_grid
    @map_renderer.position.set(campos.x, campos.y, 0)
    @scheduler.update(delta)
    super
  end

  def render_edit_mode(x, y, z, options)
    if @model.selection_stage > 1
      pos = @map_renderer.position
      @tileselection_rect.render(pos.x, pos.y, pos.z)
    end
  end

  def render_content(x, y, z, options)
    render_edit_mode x, y, z, options
    super
  end
end
