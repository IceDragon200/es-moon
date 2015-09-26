require 'scripts/models/map'

class MapEditorGuiController < State::ControllerBase
  attr_accessor :map_controller

  def on_map_changed
    @view.tileset =
      @model.tile_palette.tileset = Game.instance.database[@model.map.tileset_id]
    @map_controller.refresh_map
  end

  private def initialize_model_events
    @model.on :changed do |e|
      case e.attribute
      when :show_map_label
        on_show_map_label(e.value)
      when :show_grid
        @map_controller.on_show_grid
        @view.dashboard.toggle 7, e.value
      when :layer
        on_layer_changed(e.value)
      when :map
        on_map_changed
      end
    end

    @model.map_cursor.on :moved do |e|
      get_tile_data(@view.tile_info.tile_data, e.position)
    end
  end

  def start
    super
    initialize_model_events
    @view.map_list.on(:map_selected) { |e| on_map_selected e.map }
    @view.map_list.on(:ok) { |e| close_map_list }
  end

  def center_on_map
    bounds = @model.map.bounds
    @model.cam_cursor.position.set(bounds.cx, bounds.cy)
  end

  def camera_follow(obj)
    @model.camera.follow obj
    @view.ui_camera_posmon.obj = obj
  end

  def follow(obj)
    @view.ui_posmon.obj = obj
  end

  def refresh_follow
    if @model.keyboard_only_mode
      camera_follow @model.map_cursor
      follow @model.map_cursor
    else
      camera_follow @model.cam_cursor
      follow @model.map_cursor
    end
  end

  def toggle_grid
    @model.show_grid = !@model.show_grid
  end

  def create_map(data)
    map = Models::Map.new(data)
    map
  end

  def new_map
    @view.dashboard.enable 1
    @view.notifications.notify string: 'New Map'
    old_map = @model.map
    @model.map = create_map(
      id: "maps/new/map-#{@model.map.id}",
      name: 'New Map',
      data: Moon::DataMatrix.new(4, 4, 2, default: -1),
      tileset_id: old_map.tileset_id)
    @map_controller.refresh_map
  end

  def on_new_map_release
    @view.dashboard.disable 1
    @view.notifications.clear
  end

  def rename_map(new_name)
    if map = map_at_position(@model.map_cursor.position.floor)
      map.name = new_name
    end
  end

  def save_map
    @view.dashboard.ok 4
    @model.map.save_file
    @view.notifications.notify string: 'Saved'
  end

  def on_save_map_release
    @view.dashboard.disable 4
    #@view.notifications.clear
  end

  def set_map(map)
    @model.map = map
  end

  def on_map_selected(map)
    set_map map
    center_on_map
  end

  def close_map_list
    @view.map_list.hide.deactivate
    @view.dashboard.disable 5
    @model.map_cursor.activate
  end

  def open_map_list
    @view.map_list.refresh_list.show.activate
    @model.map_cursor.deactivate
  end

  def load_map
    @view.dashboard.ok 5
    @view.notifications.notify string: "Loading Map"
    open_map_list
  end

  def on_load_map_release
  end

  def new_zone
    @view.dashboard.enable 2
    @view.notifications.notify string: 'New Zone'
    @model.selection_stage = 1
  end

  def new_zone_stage_finish
    #id = @model.map.chunks.size + 1
    #chunk = create_chunk @model.selection_rect,
    #                     name: "New Zone #{id}"
    #chunk.uri = "/chunks/new/chunk-#{chunk.id}"

    @model.selection_stage = 0
    @model.selection_rect.clear
    @view.dashboard.disable 2
    @view.notifications.clear
  end

  def new_zone_stage
    case @model.selection_stage
    when 1
      @model.selection_stage += 1
    when 2
      new_zone_stage_finish
    end
  end

  def new_zone_revert
    case @model.selection_stage
    when 1
      @model.selection_stage = 0
      @view.dashboard.disable 2
      @view.notifications.clear
    when 2
      @model.selection_rect.clear
      @model.selection_stage -= 1
    end
  end

  def resize_map(x, y)
    if map = @view.tile_info.tile_data.map
      map.resize(map.w + x, map.h + y)
    end
  end

  private def map_zone
    tile_data = @view.tile_info.tile_data
    if map = tile_data.map
      x, y, z = tile_data.position.x, tile_data.position.y, 0
      map.zones[x, y, z] = yield(map.zones[x, y, z]).clamp(-1, 255)
    end
  end

  def increment_zone
    map_zone { |data| data + 1 }
  end

  def decrement_zone
    map_zone { |data| data - 1 }
  end

  def toggle_keyboard_mode
    @model.keyboard_only_mode = !@model.keyboard_only_mode
    if @model.keyboard_only_mode
      @view.dashboard.ok(8)
      @view.notifications.notify string: "Keyboard Only Mode : ENABLED"
    else
      @view.dashboard.disable(8)
      @view.notifications.notify string: "Keyboard Only Mode : DISABLED"
    end
    refresh_follow
  end

  def on_show_map_label(value)
    if value
      @view.dashboard.enable 9
      @view.notifications.notify string: 'Showing Chunk Labels'
    else
      @view.dashboard.disable 9
      @view.notifications.clear
    end
  end

  def on_layer_changed(layer)
    @view.layer_view.index = @model.layer
    if @model.layer < 0
      @map_controller.layer_opacity = @model.layer_opacity.map { 1.0 }
    else
      layer_opacity = @model.layer_opacity.map { 0.3 }
      layer_opacity[@model.layer] = 1.0
      @map_controller.layer_opacity = layer_opacity
    end
    if layer < 0
      @view.notifications.notify string: "Layer editing deactivated"
    else
      @view.notifications.notify string: "Layer #{layer} set for editing"
    end
  end

  def set_layer(value)
    @model.layer = value
  end

  def place_tile(tile_id)
    tile_data = @view.tile_info.tile_data
    if map = tile_data.map
      dx, dy, _ = *tile_data.position
      map.data[dx, dy, @model.layer] = tile_id
      @map_controller.refresh_map
    end
  end

  def rect_selection?
    @model.selection_stage > 0
  end

  def place_current_tile
    return unless @model.map_cursor.active?
    return if rect_selection?
    place_tile @view.tile_panel.tile_id
  end

  def sample_tile
    return unless @model.map_cursor.active?
    return if rect_selection?
    if @model.layer > -1
      @view.tile_panel.tile_id = @view.tile_info.tile_data.tile_ids[@model.layer]
    else
      tile_ids = @view.tile_info.tile_data.tile_ids
      tile_id = tile_ids.reject { |n| n == -1 }.last || -1
      @view.tile_panel.tile_id = tile_id
    end
    @view.tile_preview.tile_id = @view.tile_panel.tile_id
  end

  def erase_tile
    return unless @model.map_cursor.active?
    return if rect_selection?
    place_tile(-1)
  end

  def toggle_tile_panel
    if @tp_on
      @model.map_cursor.activate
      hide_tile_panel
      show_tile_preview
      @tp_on = false
    else
      @model.map_cursor.deactivate
      show_tile_panel
      hide_tile_preview
      @tp_on = true
    end
  end

  def select_tile(pos)
    return unless @tp_on
    @view.tile_panel.select_tile(pos)
    @view.tile_preview.tile_id = @view.tile_panel.tile_id
  end

  def move_cursor(xv, yv)
    cursor = if @model.map_cursor.active?
      @model.map_cursor
    else
      @view.tile_panel.cursor
    end
    cursor.move xv, yv
  end

  def set_camera_velocity(x, y)
    return unless @model.map_cursor.active?
    @model.cam_cursor.velocity.x = x * @model.camera_move_speed.x if x
    @model.cam_cursor.velocity.y = y * @model.camera_move_speed.y if y
  end

  def animate_map_zoom(dest)
    zoom = @model.zoom
    @model.zoom = dest
    @view.notifications.notify string: "Zoom has been disabled"
  end

  def zoom_reset
    animate_map_zoom(1.0)
  end

  def zoom_out
    animate_map_zoom(@model.zoom/2.0)
  end

  def zoom_in
    animate_map_zoom(@model.zoom*2.0)
  end

  def autosave
    save_map
    @view.notifications.notify string: "Autosaved!"
  end

  def show_help
    @view.dashboard.enable 0
    @view.notifications.notify string: "Help"
    @view.help_panel.resize nil, nil
    @view.help_panel.show
  end

  def hide_help
    @view.dashboard.disable 0
    @view.notifications.clear
    @view.help_panel.hide
  end

  def toggle_help
    if @view.help_panel.visible?
      hide_help
    else
      show_help
    end
  end

  def show_tile_info
    @view.tile_info.show
  end

  def hide_tile_info
    @view.tile_info.hide
  end

  def show_tile_panel
    @view.tile_panel.show
  end

  def hide_tile_panel
    @view.tile_panel.hide
  end

  def show_tile_preview
    @view.tile_preview.show
  end

  def hide_tile_preview
    @view.tile_preview.hide
  end

  def show_map_label
    @model.show_map_label = true
  end

  def hide_map_label
    @model.show_map_label = false
  end

  def edit_tile_palette
    state_manager.push(States::TilePaletteEditor)
  end

  def map_at_position(position)
    @model.map.bounds.contains?(position) ? @model.map : nil
  end

  def get_tile_data(tile_data, position)
    position = position.floor
    map = map_at_position(position)
    tile_data.valid = false
    if map
      tile_data.valid = true
      return if tile_data.position == position
      tile_data.map = map
      tile_data.position.set position.x, position.y, 0
      x, y, _ = *tile_data.position
      tile_data.tile_ids = map.data.sampler.pillar(x, y).to_a
      tile_data.zone_ids = map.zones_at(x, y)
      tile_data.nodes = map.nodes_at(x, y)
      tile_data.passage = map.passage_at(x, y)
    end
    tile_data
  end

  def set_cursor_position_from_mouse(position)
    return unless @model.map_cursor.active?
    return if @model.keyboard_only_mode
    @model.map_cursor.moveto @model.camera.screen_to_world(position).floor
  end

  def update(delta)
    if @model.selection_stage == 1
      @model.selection_rect.position = @model.map_cursor.position
    elsif @model.selection_stage == 2
      @model.selection_rect.resolution = @model.map_cursor.position -
                                         @model.selection_rect.position + [1, 1]
    end
    super
  end
end
