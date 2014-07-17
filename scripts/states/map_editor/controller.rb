class MapEditorController
  attr_accessor :state
  attr_accessor :model
  attr_accessor :view

  def initialize(model, view)
    @state = nil
    @model = model
    @view = view
  end

  ###
  # @param [Vector3] screen_pos
  ###
  def screen_pos_to_map_pos(screen_pos)
    (screen_pos + @camera.view.floor) / 32
  end

  def map_pos_to_screen_pos(map_pos)
    map_pos * 32 - @camera.view.floor
  end

  def screen_pos_map_reduce(screen_pos)
    screen_pos_to_map_pos(screen_pos).floor * 32 - @camera.view.floor
  end

  def new_map
  end

  def save_map
    @map.dmap.save_file
    save_chunks
  end

  def new_chunk
  end

  def save_chunks
    @map.chunks.each { |chunk| chunk.dchunk.save_file }
  end

  def rename_chunk(chunk, new_name)
  end

  def move_chunk(chunk, new_position)
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
  end

  def place_tile(tile_id)
    info = @tile_info.info
    if chunk = info[:chunk]
      dx, dy, _ = *info[:chunk_data_position]
      chunk.data[dx, dy, @model.layer] = tile_id
    end
  end

  def copy_tile
    data = @tile_info.info[:data]
    tile_id = data.reject { |n| n == -1 }.last || -1
    @tile_panel.tile_id = tile_id
  end

  def erase_tile
    place_tile(-1)
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

  def transition_transform(dest)
    zoom = @zoom
    @zoom = dest
    if @state
      @transform_transition = add_transition(zoom, dest, 0.15) do |v|
        @model.transform = Transform.scale(v, v, 1.0)
      end
    else
      @model.zoom = dest
      @model.transform = Transform.scale(@model.zoom, @model.zoom, 1.0)
    end
  end

  def zoom_reset
    transition_transform(1.0)
  end

  def zoom_out
    transition_transform(@zoom/2.0)
  end

  def zoom_in
    transition_transform(@zoom*2.0)
  end

  def show_help
    @dashboard.enable 0
  end

  def hide_help
    @dashboard.disable 0
  end

  def update_edit_mode(delta)
    mp = Mouse.position.xyz
    @cursor_position_map_pos = screen_pos_to_map_pos mp
    @tile_info.tile_position.set @cursor_position_map_pos.xy
    @cursor_position.set screen_pos_map_reduce(mp)

    @hud.update delta
    @tile_preview.tile_id = @tile_panel.tile_id

    h = Moon::Screen.height
    w = Moon::Screen.width
    @ui_posmon.position.set w - @ui_posmon.width - 48, 0, 0
    @ui_camera_posmon.position.set((w - @ui_camera_posmon.width) / 2,
                                    h - @ui_camera_posmon.height,
                                    0)

    if @tileselection_rect.active?
      @tileselection_rect.position.set map_pos_to_screen_pos(@tileselection_rect.tile_rect.xyz)

      if @selection_stage == 2
        @tileselection_rect.tile_rect.whd = @cursor_position_map_pos - @tileselection_rect.tile_rect.xyz
      end
    end
  end

  def update(delta)
    @model.cam_cursor.update delta
  end
end
