class MapEditorInputDelegate < StateInputDelegate
  def init
    super
    @control_map = ES.cache.controlmap("map_editor.yml")
  end

  def register_actor_move(input)
    input.on :press, @control_map["move_camera_left"] do
      @controller.set_camera_velocity(-1, nil)
    end

    input.on :press, @control_map["move_camera_right"] do
      @controller.set_camera_velocity(1, nil)
    end

    input.on :release, @control_map["move_camera_left"], @control_map["move_camera_right"] do
      @controller.set_camera_velocity(0, nil)
    end

    input.on :press, @control_map["move_camera_up"] do
      @controller.set_camera_velocity(nil, -1)
    end

    input.on :press, @control_map["move_camera_down"] do
      @controller.set_camera_velocity(nil, 1)
    end

    input.on :release, @control_map["move_camera_up"], @control_map["move_camera_down"] do
      @controller.set_camera_velocity(nil, 0)
    end
  end

  def register_cursor_move(input)
    cursor_freq = "200"

    input.on :held, @control_map["move_cursor_left"] do
      @controller.move_cursor(-1, 0)
    end

    input.on :held, @control_map["move_cursor_right"] do
      @controller.move_cursor(1, 0)
    end

    input.on :held, @control_map["move_cursor_up"] do
      @controller.move_cursor(0, -1)
    end

    input.on :held, @control_map["move_cursor_down"] do
      @controller.move_cursor(0, 1)
    end
  end

  def register_chunk_move(input)
    input.on :press, @control_map["move_chunk_left"] do
      @controller.move_chunk(-1, 0)
    end

    input.on :press, @control_map["move_chunk_right"] do
      @controller.move_chunk(1, 0)
    end

    input.on :press, @control_map["move_chunk_up"] do
      @controller.move_chunk(0, -1)
    end

    input.on :press, @control_map["move_chunk_down"] do
      @controller.move_chunk(0, 1)
    end
  end

  def register_zoom_controls(input)
    input.on :press, @control_map["zoom_reset"] do
      @controller.zoom_reset
    end

    input.on :press, @control_map["zoom_out"] do
      @controller.zoom_out
    end

    input.on :press, @control_map["zoom_in"] do
      @controller.zoom_in
    end
  end

  def register_tile_edit(input)
    ## copy tile
    input.on :press, @control_map["copy_tile"] do
      @controller.copy_tile
    end

    ## erase tile
    input.on :press, @control_map["erase_tile"] do
      @controller.erase_tile
    end

    input.on :press, @control_map["place_tile"] do
      @controller.place_current_tile
    end

    ## layer toggle
    input.on :press, @control_map["deactivate_layer_edit"] do
      @controller.set_layer(-1)
    end

    input.on :press, @control_map["edit_layer_0"] do
      @controller.set_layer(0)
    end

    input.on :press, @control_map["edit_layer_1"] do
      @controller.set_layer(1)
    end
  end

  def register_dashboard_help(input)
    ## help
    input.on :press, @control_map["help"] do
      @controller.show_help
    end

    input.on :release, @control_map["help"] do
      @controller.hide_help
    end
  end

  def register_dashboard_new_map(input)
    ## New Map
    input.on :press, @control_map["new_map"] do
      @controller.new_map
    end

    input.on :release, @control_map["new_map"] do
      @controller.on_new_map_release
    end
  end

  def register_dashboard_new_chunk(input)
    ## New Chunk
    input.on :press, @control_map["new_chunk"] do
      @controller.new_chunk
    end

    input.on :press, @control_map["place_tile"] do
      @controller.new_chunk_stage
    end

    input.on :press, @control_map["erase_tile"] do
      @controller.new_chunk_revert
    end
  end

  def register_dashboard_controls(input)
    register_dashboard_help(input)
    register_dashboard_new_map(input)
    register_dashboard_new_chunk(input)

    input.on :press, @control_map["save_map"] do
      @controller.save_map
    end

    input.on :release, @control_map["save_map"] do
      @controller.on_save_map_release
    end

    input.on :press, @control_map["load_chunks"] do
      @controller.load_chunks
    end

    input.on :release, @control_map["load_chunks"] do
      @controller.on_load_chunks_release
    end

    input.on :press, @control_map["toggle_keyboard_mode"] do
      @controller.toggle_keyboard_mode
    end

    ## Show Chunk Labels
    input.on :press, @control_map["show_chunk_labels"] do
      @controller.show_chunk_labels
      @controller.hide_tile_info
    end

    input.on :release, @control_map["show_chunk_labels"] do
      @controller.hide_chunk_labels
      @controller.show_tile_info
    end

    ## Edit Tile Palette
    input.on :press, @control_map["edit_tile_palette"] do
      cvar["tile_palette"] = @model.tile_palette
      @controller.edit_tile_palette
    end
  end

  def register_events(input)
    register_actor_move(input)
    register_cursor_move(input)
    register_chunk_move(input)
    register_zoom_controls(input)
    register_tile_edit(input)
    register_dashboard_controls(input)

    input.on :press, @control_map["center_on_map"] do
      bounds = @model.map.bounds
      @model.cam_cursor.position.set(bounds.cx, bounds.cy, 0)
    end

    ## tile panel
    input.on :press, @control_map["show_tile_panel"] do
      @controller.show_tile_panel
      @controller.hide_tile_preview
    end

    input.on :press, @control_map["show_tile_panel"] do
      @controller.hide_tile_panel
      @controller.show_tile_preview
    end

    input.on :press, @control_map["place_tile"] do
      @controller.select_tile(Input::Mouse.position-[0,16])
    end
  end

  def register(input)
    input.alias_event(:held, :repeat)
    input.alias_event(:held, :press)
    register_events(input)
  end
end
