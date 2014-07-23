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

    input.on :press, @control_map["move_cursor_left"] do
      @controller.move_cursor(-1, 0)
      @scheduler.remove(@horz_move_job)
      @horz_move_job = @scheduler.every cursor_freq do
        @controller.move_cursor(-1, 0)
      end
    end

    input.on :press, @control_map["move_cursor_right"] do
      @controller.move_cursor(1, 0)
      @scheduler.remove(@horz_move_job)
      @horz_move_job = @scheduler.every cursor_freq do
        @controller.move_cursor(1, 0)
      end
    end

    input.on :release, @control_map["move_cursor_left"], @control_map["move_cursor_right"] do
      @scheduler.remove(@horz_move_job)
    end

    input.on :press, @control_map["move_cursor_up"] do
      @controller.move_cursor(0, -1)
      @scheduler.remove(@vert_move_job)
      @vert_move_job = @scheduler.every cursor_freq do
        @controller.move_cursor(0, -1)
      end
    end

    input.on :press, @control_map["move_cursor_down"] do
      @controller.move_cursor(0, 1)
      @scheduler.remove(@vert_move_job)
      @vert_move_job = @scheduler.every cursor_freq do
        @controller.move_cursor(0, 1)
      end
    end

    input.on :release, @control_map["move_cursor_up"], @control_map["move_cursor_down"] do
      @scheduler.remove(@vert_move_job)
    end
  end

  def register_chunk_move(input)
    modespace input, :edit do |subinput|
      subinput.on :press, @control_map["move_chunk_left"] do
        @controller.move_chunk(-1, 0)
      end

      subinput.on :press, @control_map["move_chunk_right"] do
        @controller.move_chunk(1, 0)
      end

      subinput.on :press, @control_map["move_chunk_up"] do
        @controller.move_chunk(0, -1)
      end

      subinput.on :press, @control_map["move_chunk_down"] do
        @controller.move_chunk(0, 1)
      end
    end
  end

  def register_zoom_controls(input)
    modespace input, :edit do |subinput|
      subinput.on :press, @control_map["zoom_reset"] do
        @controller.zoom_reset
      end

      subinput.on :press, @control_map["zoom_out"] do
        @controller.zoom_out
      end

      subinput.on :press, @control_map["zoom_in"] do
        @controller.zoom_in
      end
    end
  end

  def register_tile_edit(input)
    modespace input, :edit do |subinput|
      ## copy tile
      subinput.on :press, @control_map["copy_tile"] do
        @controller.copy_tile
      end

      ## erase tile
      subinput.on :press, @control_map["erase_tile"] do
        @controller.erase_tile
      end

      subinput.on :press, @control_map["place_tile"] do
        @controller.place_current_tile
      end

      ## layer toggle
      subinput.on :press, @control_map["deactivate_layer_edit"] do
        @controller.set_layer(-1)
      end

      subinput.on :press, @control_map["edit_layer_0"] do
        @controller.set_layer(0)
      end

      subinput.on :press, @control_map["edit_layer_1"] do
        @controller.set_layer(1)
      end
    end
  end

  def register_dashboard_help(input)
    modespace input, :edit do |subinput|
      ## help
      subinput.on :press, @control_map["help"] do
        @mode.push :help
        @controller.show_help
      end

      modespace input, :help do |subinp2|
        subinp2.on :release, @control_map["help"] do
          @mode.pop
          @controller.hide_help
        end
      end
    end
  end

  def register_dashboard_new_map(input)
    modespace input, :edit do |subinput|
      ## New Map
      subinput.on :press, @control_map["new_map"] do
        @controller.new_map
        @mode.push :new_map
      end

      modespace input, :new_map do |subinp2|
        subinp2.on :release, @control_map["new_map"] do
          @controller.on_new_map_release
          @mode.pop
        end
      end
    end
  end

  def register_dashboard_new_chunk(input)
    modespace input, :edit do |subinput|
      ## New Chunk
      subinput.on :press, @control_map["new_chunk"] do
        @mode.push :new_chunk
        @controller.new_chunk
      end

      modespace input, :new_chunk do |inp2|
        inp2.on :press, @control_map["place_tile"] do
          if @model.selection_stage == 1
            @model.selection_stage += 1
          elsif @model.selection_stage == 2
            id = @model.map.chunks.size+1
            @controller.create_chunk @view.tileselection_rect.tile_rect,
                         id: id, name: "New Chunk #{id}", uri: "/chunks/new/chunk-#{id}"

            @model.selection_stage = 0
            @model.selection_rect.clear
            @view.dashboard.disable 2
            @mode.pop
            @view.notifications.clear
          end
        end
        inp2.on :press, @control_map["erase_tile"] do
          if @model.selection_stage == 1
            @model.selection_stage = 0
            @view.dashboard.disable 2
            @mode.pop
            @view.notifications.clear
          elsif @model.selection_stage == 2
            @model.selection_rect.clear
            @model.selection_stage -= 1
          end
        end
      end
    end
  end

  def register_dashboard_controls(input)
    register_dashboard_help(input)
    register_dashboard_new_map(input)
    register_dashboard_new_chunk(input)

    modespace input, :edit do
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
        @mode.push :show_chunk_labels
      end

      modespace input, :show_chunk_labels do |inp2|
        inp2.on :release, @control_map["show_chunk_labels"] do
          @controller.hide_chunk_labels
          @controller.show_tile_info
          @mode.pop
        end
      end

      ## Edit Tile Palette
      input.on :press, @control_map["edit_tile_palette"] do
        cvar["tile_palette"] = @model.tile_palette
        @controller.edit_tile_palette
      end
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

    modespace input, :view do |input|
      ## mode toggle
      input.on :press, @control_map["enter_edit_mode"] do
        @mode.change :edit
      end
    end

    # These are the commands tof the edit mode, currently most commands
    # are broken due to the MVC movement, some actions require access
    # to both the model and controller, as a result its hard to determine
    # how to properly and cleanly port the code.
    # The idea is:
    #   State <-> Controller <-> Model <-> Controller <-> View
    # At no point should the state directly communicate with the Model
    # or View
    modespace input, :edit do |input|
      input.on :press, @control_map["enter_view_mode"] do
        @mode.change :view
      end

      ## tile panel
      input.on :press, @control_map["show_tile_panel"] do
        @mode.push :tile_select
        @controller.show_tile_panel
        @controller.hide_tile_preview
      end

      modespace input, :tile_select do |inp2|
        inp2.on :press, @control_map["show_tile_panel"] do
          @mode.pop
          @controller.hide_tile_panel
          @controller.show_tile_preview
        end
        inp2.on :press, @control_map["place_tile"] do
          @controller.select_tile(Input::Mouse.position-[0,16])
        end
      end
    end
  end

  def register(input)
    register_events(input)
  end
end
