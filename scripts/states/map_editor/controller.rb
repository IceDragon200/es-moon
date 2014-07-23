class MapEditorController < StateController

  ###
  # @param [Vector3] screen_pos
  ###
  def screen_pos_to_map_pos(screen_pos)
    @view.screen_pos_to_map_pos(screen_pos)
  end

  def map_pos_to_screen_pos(map_pos)
    @view.map_pos_to_screen_pos(map_pos)
  end

  def screen_pos_map_reduce(screen_pos)
    @view.screen_pos_map_reduce(screen_pos)
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

  def new_map
    @view.dashboard.enable 1
    @view.notifications.notify string: "New Map (NYI)"
  end

  def on_new_map_release
    @view.dashboard.disable 1
    @view.notifications.clear
  end

  def save_map
    @view.dashboard.ok 4
    @model.map.to_map.save_file
    save_chunks
    @view.notifications.notify string: "Saved"
  end

  def on_save_map_release
    @view.dashboard.disable 4
    @view.notifications.clear
  end

  def new_chunk
    @view.dashboard.enable 2
    @view.notifications.notify string: "New Chunk"
    @model.selection_stage = 1
  end

  def create_chunk(bounds, data)
    chunk          = ES::DataModel::EditorChunk.new(data)
    chunk.position = bounds.xyz
    chunk.data     = DataMatrix.new(bounds.w, bounds.h, 2, default: -1)
    chunk.passages = Table.new(bounds.w, bounds.h)
    chunk.flags    = DataMatrix.new(bounds.w, bounds.h, 2)
    chunk.tileset  = Database.find(:tileset, uri: "/tilesets/common")
    @model.map.chunks << chunk
    #create_tilemaps
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

  def rename_chunk(new_name)
    if chunk = chunk_at_position(@model.map_cursor.position.floor)
      chunk.name = new_name
    end
  end

  def move_chunk(x, y)
    if chunk = chunk_at_position(@model.map_cursor.position.xy.floor)
      pos = [x, y, 0]
      chunk.position += pos
      @model.map_cursor.position += pos
    end
  end

  def create_chunk(rect, data)
    size = Vector3.new(*rect.wh, 2)

    data[:data] = begin
      dm = DataMatrix.new(*size, default: -1)
      dm
    end
    data[:flags] = begin
      dm = DataMatrix.new(*size)
      dm
    end
    data[:passages] = Table.new(*size.xy)

    dchunk = ES::DataModel::Chunk.new data

    chunk = ES::GameObject::Chunk.new
    chunk.setup(dchunk)

    @map.chunks << chunk
    @map.dmap.chunks << { name: dchunk.name }
    chunk_p = @map.dmap.chunk_position
    chunk_p[chunk_p.size] = rect.xyz
    @map.refresh
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

  def set_layer(layer)
    @model.layer = layer
    @view.layer_view.index = @model.layer
    if @model.layer < 0
      @model.layer_opacity.map! { 1.0 }
    else
      @model.layer_opacity.map! { 0.3 }
      @model.layer_opacity[@model.layer] = 1.0
    end
    if layer < 0
      @view.notifications.notify string: "Layer editing deactivated"
    else
      @view.notifications.notify string: "Layer #{layer} set for editing"
    end
  end

  def place_tile(tile_id)
    tile_data = @view.tile_info.tile_data
    if chunk = tile_data.chunk
      dx, dy, _ = *tile_data.chunk_data_position
      chunk.data[dx, dy, @model.layer] = tile_id
    end
  end

  def place_current_tile
    place_tile @view.tile_panel.tile_id
  end

  def copy_tile
    tile_ids = @view.tile_info.tile_data.tile_ids
    tile_id = tile_ids.reject { |n| n == -1 }.last || -1
    @view.tile_panel.tile_id = tile_id
  end

  def erase_tile
    place_tile(-1)
  end

  def select_tile(pos)
    @view.tile_panel.select_tile(pos)
  end

  def move_cursor(xv, yv)
    @model.map_cursor.position += [xv, yv, 0]
  end

  def animate_map_zoom(dest)
    zoom = @model.zoom
    @model.zoom = dest
    puts "Zoom has been disabled"
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
  end

  def hide_help
    @view.dashboard.disable 0
    @view.notifications.clear
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
    @view.dashboard.enable 9
    @model.flag_show_chunk_labels = true
    @view.notifications.notify string: "Showing Chunk Labels"
  end

  def hide_chunk_labels
    @view.dashboard.disable 9
    @model.flag_show_chunk_labels = false
    @view.notifications.clear
  end

  def edit_tile_palette
    State.push(ES::States::TilePaletteEditor)
  end

  def chunk_at_position(position)
    map = @model.map
    chunk = map.chunks.find do |c|
      c.bounds.inside?(position)
    end
  end

  def get_tile_data(position)
    position = position.floor
    chunk = chunk_at_position(position)
    tile_data = ES::DataModel::TileData.new
    if chunk
      tile_data.chunk = chunk
      tile_data.data_position = position.xyz
      tile_data.chunk_data_position = position.xyz - chunk.position.xyz
      tile_data.tile_ids = chunk.data.pillar_a(*tile_data.chunk_data_position.xy)
      tile_data.passage = chunk.passages[*tile_data.chunk_data_position.xy]
    end
    tile_data
  end

  def update_cursor_position(delta)
    unless @model.keyboard_only_mode
      @model.map_cursor.position = screen_pos_to_map_pos(Input::Mouse.position.xyz).floor
    end
    @view.tile_info.tile_data = get_tile_data(@model.map_cursor.position.xy)
  end

  def update_edit_mode(delta)
    update_cursor_position(delta)

    @view.tile_preview.tile_id = @view.tile_panel.tile_id

    if @model.selection_stage == 1
      @model.selection_rect.xyz = @model.map_cursor.position
    elsif @model.selection_stage == 2
      @model.selection_rect.whd = @model.map_cursor.position -
                                  @model.selection_rect.xyz
    end
    @view.tileselection_rect.tile_rect = @model.selection_rect
  end

  def update(delta)
    @model.update(delta)
  end
end
