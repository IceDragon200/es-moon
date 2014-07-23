require "scripts/states/map_editor/model"
require "scripts/states/map_editor/view"
require "scripts/states/map_editor/controller"
require "scripts/states/map_editor/input_delegate"

module ES
  module States
    class MapEditor < Base
      def init
        super
        @screen_rect = Screen.rect.contract(16)
        @control_map = ES.cache.controlmap("map_editor.yml")

        @mode = StateMachine.new
        @mode.on_mode_change = ->(mode){ on_mode_change(mode) }

        @model = MapEditorModel.new
        @view = MapEditorView.new @model
        @controller = MapEditorController.new @model, @view

        create_world
        create_map

        create_tilemaps

        @grid_underlay = Sprite.new("media/ui/grid_32x32_ff777777.png")
        @grid_overlay  = Sprite.new("media/ui/grid_32x32_ffffffff.png")
        @chunk_borders = Spritesheet.new("media/ui/chunk_outline_3x3.png", 32, 32)
        @mode_icon = ModeIcon.new({
          view: "film",
          edit: "gear",
          help: "book",
          show_chunk_labels: "search",
          debug_shell: "dashboard"
        })

        @mode_icon.position.set(Rect.new(0, 0, 32, 32).align("bottom right", @screen_rect).xyz)
        @mode_icon.color = Vector4.new(1, 1, 1, 1)

        create_autosave_interval


        register_events


        tileset = Database.find(:tileset, uri: "/tilesets/common")
        @model.tile_palette.tileset = tileset
        @view.tileset = ES.cache.tileset(tileset.filename,
                                         tileset.cell_width, tileset.cell_height)

        @controller.set_layer(-1)
        @controller.refresh_follow
        @mode.push :view
      end

      def create_world
        @world = World.new
      end

      def create_map
        map = Database.find(:map, uri: "/maps/school/f1")
        @model.map = map.to_editor_map
        @model.map.chunks = map.chunks.map do |chunk_head|
          chunk = Database.find(:chunk, uri: chunk_head.uri)
          editor_chunk = chunk.to_editor_chunk
          editor_chunk.position = chunk_head.position
          editor_chunk.tileset = Database.find(:tileset, uri: chunk.tileset.uri)
          editor_chunk
        end
      end

      def create_tilemaps
        @chunk_renderers = @model.map.chunks.map do |chunk|
          renderer = ChunkRenderer.new(chunk)
          renderer.layer_opacity = @layer_opacity
          renderer
        end
      end

      def create_autosave_interval
        @autosave_interval = @scheduler.every("3m") do
          @controller.autosave
        end.tag("autosave")
      end

      def modespace(mode)
        @_wrappers ||= []
        (@_modes ||=[]).push mode
        modes = @_modes.dup

        wrapper = InputContext.new(@input) do |f, i, *a, &b|
          i.send(f, *a) { |*a2, &b2| b.call(*a2, &b2) if @mode.trace?(modes) }
        end

        @_wrappers.push wrapper

        yield @_wrappers.last

        @_wrappers.pop
        @_modes = @_modes.slice 0, @_modes.size-1
      end

      def register_actor_move
        @cam_move_speed = 8
        @input.on :press, @control_map["move_camera_left"] do
          @model.cam_cursor.velocity.x = -1 * @cam_move_speed
        end
        @input.on :press, @control_map["move_camera_right"] do
          @model.cam_cursor.velocity.x = 1 * @cam_move_speed
        end
        @input.on :release, @control_map["move_camera_left"], @control_map["move_camera_right"] do
          @model.cam_cursor.velocity.x = 0
        end

        @input.on :press, @control_map["move_camera_up"] do
          @model.cam_cursor.velocity.y = -1 * @cam_move_speed
        end
        @input.on :press, @control_map["move_camera_down"] do
          @model.cam_cursor.velocity.y = 1 * @cam_move_speed
        end
        @input.on :release, @control_map["move_camera_up"], @control_map["move_camera_down"] do
          @model.cam_cursor.velocity.y = 0
        end
      end

      def register_cursor_move
        cursor_freq = "200"

        @input.on :press, @control_map["move_cursor_left"] do
          @controller.move_cursor(-1, 0)
          @scheduler.remove(@horz_move_job)
          @horz_move_job = @scheduler.every cursor_freq do
            @controller.move_cursor(-1, 0)
          end
        end

        @input.on :press, @control_map["move_cursor_right"] do
          @controller.move_cursor(1, 0)
          @scheduler.remove(@horz_move_job)
          @horz_move_job = @scheduler.every cursor_freq do
            @controller.move_cursor(1, 0)
          end
        end

        @input.on :release, @control_map["move_cursor_left"], @control_map["move_cursor_right"] do
          @scheduler.remove(@horz_move_job)
        end

        @input.on :press, @control_map["move_cursor_up"] do
          @controller.move_cursor(0, -1)
          @scheduler.remove(@vert_move_job)
          @vert_move_job = @scheduler.every cursor_freq do
            @controller.move_cursor(0, -1)
          end
        end

        @input.on :press, @control_map["move_cursor_down"] do
          @controller.move_cursor(0, 1)
          @scheduler.remove(@vert_move_job)
          @vert_move_job = @scheduler.every cursor_freq do
            @controller.move_cursor(0, 1)
          end
        end

        @input.on :release, @control_map["move_cursor_up"], @control_map["move_cursor_down"] do
          @scheduler.remove(@vert_move_job)
        end
      end

      def register_chunk_move
        modespace :edit do |input|
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
      end

      def register_zoom_controls
        modespace :edit do |input|
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
      end

      def register_tile_edit
        modespace :edit do |input|
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
      end

      def register_dashboard_help
        modespace :edit do |input|
          ## help
          input.on :press, @control_map["help"] do
            @mode.push :help
            @controller.show_help
          end

          modespace :help do |inp2|
            inp2.on :release, @control_map["help"] do
              @mode.pop
              @controller.hide_help
            end
          end
        end
      end

      def register_dashboard_new_map
        modespace :edit do |input|
          ## New Map
          input.on :press, @control_map["new_map"] do
            @controller.new_map
            @mode.push :new_map
          end

          modespace :new_map do |inp2|
            inp2.on :release, @control_map["new_map"] do
              @controller.on_new_map_release
              @mode.pop
            end
          end
        end
      end

      def register_dashboard_new_chunk
        modespace :edit do
          ## New Chunk
          input.on :press, @control_map["new_chunk"] do
            @mode.push :new_chunk
            @controller.new_chunk
          end

          @model.selection_stage = 0
          modespace :new_chunk do |inp2|
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

      def register_dashboard_controls
        register_dashboard_help
        register_dashboard_new_map
        register_dashboard_new_chunk

        modespace :edit do
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

          modespace :show_chunk_labels do |inp2|
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

      def launch_debug_shell
        @debug_shell = DebugShell.new
        @debug_shell.position.set(0, 0, 0)
      end

      def stop_debug_shell
        @debug_shell = nil
      end

      def register_events
        register_actor_move
        register_cursor_move
        register_chunk_move
        register_zoom_controls
        register_tile_edit
        register_dashboard_controls

        @input.on :press, :left_bracket do
          @scheduler.p_job_table
        end

        @input.on :press, :backslash do
          if @mode.is?(:debug_shell)
            @mode.pop
            stop_debug_shell
          else
            launch_debug_shell
            @mode.push :debug_shell
          end
        end

        @input.typing do |e|
          @debug_shell.string += e.char if @mode.is?(:debug_shell)
        end

        @input.on :press, :backspace do
          @debug_shell.string = @debug_shell.string.chop if @mode.is?(:debug_shell)
        end

        @input.on :repeat, :backspace do
          @debug_shell.string = @debug_shell.string.chop if @mode.is?(:debug_shell)
        end

        @input.on :press, :enter do
          @debug_shell.exec if @mode.is?(:debug_shell)
        end

        @input.on :press, @control_map["center_on_map"] do
          bounds = @model.map.bounds
          @model.cam_cursor.position.set(bounds.cx, bounds.cy, 0)
        end

        modespace :view do |input|
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
        modespace :edit do |input|
          input.on :press, @control_map["enter_view_mode"] do
            @mode.change :view
          end

          ## tile panel
          input.on :press, @control_map["show_tile_panel"] do
            @mode.push :tile_select
            @controller.show_tile_panel
            @controller.hide_tile_preview
          end

          modespace :tile_select do |inp2|
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

      def switch_mode_icon(mode)
        time = "150"
        fade_color = Vector4.new(0, 0, 0, 0)
        base_color = Vector4.new(1, 1, 1, 1)

        @scheduler.remove(@mode_icon_job)
        @mode_icon_job = @scheduler.in time do
          add_transition @mode_icon.color, base_color, time do |value|
            @mode_icon.color = value
          end
          @mode_icon.mode = mode
        end

        remove_transition(@mode_icon_transition)
        @mode_icon_transition = add_transition @mode_icon.color, fade_color, time do |value|
          @mode_icon.color = value
        end
      end

      def on_mode_change(mode)
        switch_mode_icon(mode)
      end

      def update_world(delta)
        return if @mode.is? :help
        @world.update(delta)
      end

      def update(delta)
        @view.update(delta)
        @controller.update(delta)

        if @mode.has?(:edit)
          @controller.update_edit_mode(delta)
        end
        update_world(delta)
        super delta
      end

      def render_map
        pos = -@model.camera.view.floor
        @chunk_renderers.each do |renderer|
          lp = (pos + renderer.position * 32)
          @grid_underlay.clip_rect = Rect.new(0, 0, *(renderer.chunk.bounds.wh*32))
          @grid_underlay.render(*lp)
          renderer.render(*pos)
          if @mode.is? :show_chunk_labels
            @chunk_borders.render(*lp, 0)
            @chunk_borders.render(*lp+[@grid_underlay.clip_rect.width-32,0,0], 2)
            @chunk_borders.render(*lp+[0,@grid_underlay.clip_rect.height-32,0], 6)
            @chunk_borders.render(*lp+(@grid_underlay.clip_rect.whd-[32,32,0]), 8)
          end
          #@grid_overlay.clip_rect = Rect.new(0, 0, *@grid_underlay.clip_rect.wh)
          #@grid_overlay.render(*pos)
        end
      end

      def render
        render_map
        if @mode.is? :help
          @view.render_help_mode
        elsif @mode.has? :edit
          @view.render_edit_mode
        end
        @mode_icon.render
        @debug_shell.render if @debug_shell
        super
      end
    end
  end
end
