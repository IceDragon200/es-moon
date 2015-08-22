require 'state_mvc/input_delegate_base'

class MapEditorInputDelegate < State::InputDelegateBase
  def init
    super
    @control_map = ES.game.data_cache.controlmap('map_editor')
  end

  def on_keys(type, *args, &block)
    keys = args.flatten.map(&:to_sym)
    input.on(Array[type].flatten) do |e, elm|
      block.call(e, elm) if keys.include?(e.key)
    end
  end

  def on_press(*args, &block)
    on_keys(:press, *args, &block)
  end

  def on_held(*args, &block)
    on_keys([:press, :repeat], *args, &block)
  end

  def on_release(*args, &block)
    on_keys(:release, *args, &block)
  end

  def register_actor_move
    on_press @control_map['move_camera_left'] do
      @controller.set_camera_velocity(-1, nil)
    end

    on_press @control_map['move_camera_right'] do
      @controller.set_camera_velocity(1, nil)
    end

    on_release @control_map['move_camera_left'], @control_map['move_camera_right'] do
      @controller.set_camera_velocity(0, nil)
    end

    on_press @control_map['move_camera_up'] do
      @controller.set_camera_velocity(nil, -1)
    end

    on_press @control_map['move_camera_down'] do
      @controller.set_camera_velocity(nil, 1)
    end

    on_release @control_map['move_camera_up'], @control_map['move_camera_down'] do
      @controller.set_camera_velocity(nil, 0)
    end
  end

  def register_cursor_move
    on_held @control_map['move_cursor_left'] do
      @controller.move_cursor(-1, 0)
    end

    on_held @control_map['move_cursor_right'] do
      @controller.move_cursor(1, 0)
    end

    on_held @control_map['move_cursor_up'] do
      @controller.move_cursor(0, -1)
    end

    on_held @control_map['move_cursor_down'] do
      @controller.move_cursor(0, 1)
    end
  end

  def register_chunk_move
    on_press @control_map['move_chunk_left'] do
      @controller.move_chunk(-1, 0)
    end

    on_press @control_map['move_chunk_right'] do
      @controller.move_chunk(1, 0)
    end

    on_press @control_map['move_chunk_up'] do
      @controller.move_chunk(0, -1)
    end

    on_press @control_map['move_chunk_down'] do
      @controller.move_chunk(0, 1)
    end
  end

  def register_chunk_resize
    on_press @control_map['resize_chunk_horz_plus'] do
      @controller.resize_chunk(1, 0)
    end

    on_press @control_map['resize_chunk_horz_minus'] do
      @controller.resize_chunk(-1, 0)
    end

    on_press @control_map['resize_chunk_vert_plus'] do
      @controller.resize_chunk(0, 1)
    end

    on_press @control_map['resize_chunk_vert_minus'] do
      @controller.resize_chunk(0, -1)
    end

  end

  def register_zoom_controls
    on_press @control_map['zoom_reset'] do
      @controller.zoom_reset
    end

    on_press @control_map['zoom_out'] do
      @controller.zoom_out
    end

    on_press @control_map['zoom_in'] do
      @controller.zoom_in
    end
  end

  def register_tile_edit
    ## copy tile
    on_press @control_map['sample_tile'] do
      @controller.sample_tile
    end

    ## erase tile
    on_held @control_map['erase_tile'] do
      @controller.erase_tile
    end

    on_held @control_map['place_tile'] do
      @controller.place_current_tile
    end

    ## layer toggle
    on_press @control_map['deactivate_layer_edit'] do
      @controller.set_layer(-1)
    end

    on_press @control_map['edit_layer_0'] do
      @controller.set_layer(0)
    end

    on_press @control_map['edit_layer_1'] do
      @controller.set_layer(1)
    end
  end

  def register_dashboard_help
    ## help
    on_press @control_map['help'] do
      @controller.toggle_help
    end
  end

  def register_dashboard_new_map
    ## New Map
    on_press @control_map['new_map'] do
      @controller.new_map
    end

    on_release @control_map['new_map'] do
      @controller.on_new_map_release
    end
  end

  def register_dashboard_new_chunk
    ## New Chunk
    on_press @control_map['new_chunk'] do
      @controller.new_chunk
    end

    on_press @control_map['place_tile'] do
      @controller.new_chunk_stage
    end

    on_press @control_map['erase_tile'] do
      @controller.new_chunk_revert
    end
  end

  def register_dashboard_controls
    register_dashboard_help
    register_dashboard_new_map
    register_dashboard_new_chunk

    on_press @control_map['save_map'] do
      @controller.save_map
    end

    on_release @control_map['save_map'] do
      @controller.on_save_map_release
    end

    on_press @control_map['load_chunks'] do
      @controller.load_chunks
    end

    on_release @control_map['load_chunks'] do
      @controller.on_load_chunks_release
    end

    on_press @control_map['toggle_keyboard_mode'] do
      @controller.toggle_keyboard_mode
    end

    ## Show Chunk Labels
    on_press @control_map['show_chunk_labels'] do
      @controller.show_chunk_labels
      @controller.hide_tile_info
    end

    on_release @control_map['show_chunk_labels'] do
      @controller.hide_chunk_labels
      @controller.show_tile_info
    end

    ## Show Chunk Labels
    on_press @control_map['toggle_grid'] do
      @controller.toggle_grid
    end

    ## Edit Tile Palette
    on_press @control_map['edit_tile_palette'] do
      cvar['tile_palette'] = @model.tile_palette
      @controller.edit_tile_palette
    end
  end

  def register_events
    puts "Registering #{self.class} to #{input.to_s}"
    register_actor_move
    register_cursor_move
    register_chunk_move
    register_chunk_resize
    register_zoom_controls
    register_tile_edit
    register_dashboard_controls

    on_press @control_map['center_on_map'] do
      @controller.center_on_map
    end

    ## tile panel
    on_press @control_map['toggle_tile_panel'] do
      @controller.toggle_tile_panel
    end

    on_press @control_map['place_tile'] do
      @controller.select_tile(engine.input.mouse.position - Moon::Vector2.new(0, 16))
    end
  end
end
