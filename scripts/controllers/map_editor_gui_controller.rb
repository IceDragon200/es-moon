require 'scripts/models/map'

class MapEditorGuiController < State::ControllerBase
  attr_accessor :map_controller

  def start
    super

    @model.on :changed do |e|
      case e.attribute
      when :show_chunk_labels
        on_show_chunk_labels(e.value)
      when :show_grid
        @map_controller.on_show_grid
        @view.dashboard.toggle 7, e.value
      when :layer
        on_layer_changed(e.value)
      end
    end

    @model.map_cursor.on :moved do |e|
      get_tile_data(@view.tile_info.tile_data, e.position)
    end
  end

  def center_on_map
    bounds = @model.map.bounds
    @model.cam_cursor.position.set(bounds.cx, bounds.cy, 0)
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

  def new_map
    @view.dashboard.enable 1
    @view.notifications.notify string: 'New Map'
    @model.map = create_map(name: 'New Map')
    @model.map.id = "maps/new/map-#{@model.map.id}"
    @model.map.data =
    create_chunk(Moon::Rect.new(0, 0, 4, 4), name: "New Chunk #{@model.map.chunks.size}")
  end

  def on_new_map_release
    @view.dashboard.disable 1
    @view.notifications.clear
  end

  def save_map
    @view.dashboard.ok 4
    @model.map.save_file
    @view.notifications.notify string: 'Saved'
  end

  def on_save_map_release
    @view.dashboard.disable 4
    @view.notifications.clear
  end

  def new_chunk
    @view.dashboard.enable 2
    @view.notifications.notify string: 'New Chunk'
    @model.selection_stage = 1
  end

  def new_chunk_stage_finish
    id = @model.map.chunks.size+1
    chunk = create_chunk @model.selection_rect,
                         name: "New Chunk #{id}"
    chunk.uri = "/chunks/new/chunk-#{chunk.id}"

    @model.selection_stage = 0
    @model.selection_rect.clear
    @view.dashboard.disable 2
    @view.notifications.clear
  end

  def new_chunk_stage
    case @model.selection_stage
    when 1
      @model.selection_stage += 1
    when 2
      new_chunk_stage_finish
    end
  end

  def new_chunk_revert
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

  def create_chunk(bounds, data)
    chunk          = Models::EditorChunk.new(data)
    chunk.position = Moon::Vector3.new(bounds.x, bounds.y, 0)
    chunk.data     = Moon::DataMatrix.new(bounds.w, bounds.h, 2, default: -1)
    chunk.passages = Moon::Table.new(bounds.w, bounds.h)
    chunk.tileset  = Models::Tileset.find_by(uri: '/tilesets/common')
    @model.map.chunks << chunk
    @map_controller.refresh_map
    chunk
  end

  def create_map(data)
    map = ES::EditorMap.new(data)
    map
  end

  def save_chunks
    @model.map.chunks.each { |chunk| chunk.to_chunk.save_file }
  end

  def load_chunks
    @view.dashboard.ok 5
    @view.notifications.notify string: "Loading ... (NYI)"
  end

  def on_load_chunks_release
    @view.dashboard.disable 5
  end

  def rename_map(new_name)
    if map = map_at_position(@model.map_cursor.position.floor)
      map.name = new_name
    end
  end

  def move_map(x, y)
    if chunk = map_at_position(@model.map_cursor.position.floor)
      pos = [x, y]
      chunk.position += Moon::Vector3[pos, 0]
      @model.map_cursor.move pos
    end
  end

  def resize_chunk(x, y)
    if chunk = map_at_position(@model.map_cursor.position.floor)
      chunk.resize(chunk.w + x, chunk.h + y)
    end
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

  def on_show_chunk_labels(value)
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
    if chunk = tile_data.chunk
      dx, dy, _ = *tile_data.chunk_data_position
      chunk.data[dx, dy, @model.layer] = tile_id
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

  def show_chunk_labels
    @model.show_chunk_labels = true
  end

  def hide_chunk_labels
    @model.show_chunk_labels = false
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
      tile_data.passage = map.passage_at(*tile_data.position.xy)
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
