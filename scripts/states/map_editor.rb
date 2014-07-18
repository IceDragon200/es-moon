require "scripts/states/map_editor/controller"
require "scripts/states/map_editor/model"
require "scripts/states/map_editor/view"
require "scripts/states/map_editor/mode_stack"

module ES
  module States
    class MapEditor < Base
      def init
        super
        @control_map = ES.cache.controlmap("map_editor.yml")

        @model = MapEditorModel.new
        @view = MapEditorView.new @model
        @controller = MapEditorController.new @model, @view

        create_world
        create_map

        create_tilemaps

        @font_awesome = ES.cache.font("awesome", 32)
        @charmap_awesome = ES.cache.charmap("awesome.yml")
        @mode_icon_rect = Rect.new(0, 0, 32, 32)
        LayoutHelper.align("bottom right", @mode_icon_rect, Screen.rect.contract(16))


        @mode_icon_color = Vector4.new(1, 1, 1, 1)
        @mode_icon = ""

        @mode = ModeStack.new
        @mode.on_mode_change = ->(mode){ on_mode_change(mode) }
        @mode.push :view

        create_autosave_interval

        @controller.set_layer(-1)

        register_events

        @controller.camera_follow @model.cam_cursor
        @controller.follow @model.map_cursor

        tileset = Database.find(:tileset, uri: "/tilesets/common")
        @view.tileset = ES.cache.tileset(tileset.filename,
                                         tileset.cell_width, tileset.cell_height)
        @transform_transition = nil
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
          renderer = ChunkRenderer.new
          renderer.chunk = chunk
          renderer.position.set(chunk.position)
          renderer.layer_opacity = @layer_opacity
          renderer
        end
      end

      def create_autosave_interval
        @autosave_interval = @scheduler.every(60 * 3) do
          @controller.save_map
          @view.notifications.notify string: "Autosaved!"
        end
      end

      def modespace(mode)
        @_wrappers ||= []
        (@_modes ||=[]).push mode
        modes = @_modes.dup

        wrapper = InputContext.new(@input) do |i, *a, &b|
          i.on(*a) { |*a2, &b2| b.call(*a2, &b2) if @mode.trace?(modes) }
        end
        #wrapper = InputContext.new(@_wrappers.last||@input) do |i, *a, &b|
        #  i.on(*a) { |*a2, &b2| b.call(*a2, &b2) if @mode.trace?(modes) }
        #end

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

      def register_events
        register_actor_move

        # These are the commands tof the edit mode, currently most commands
        # are broken due to the MVC movement, some actions require access
        # to both the model and controller, as a result its hard to determine
        # how to properly and cleanly port the code.
        # The idea is:
        #   State <-> Controller <-> Model <-> Controller <-> View
        # At no point should the state directly communicate with the Model
        # or View
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

          ## New Chunk
          input.on :press, @control_map["new_chunk"] do
            @mode.push :new_chunk
            @controller.new_chunk
          end

          @model.selection_stage = 0
          modespace :new_chunk do |inp2|
            inp2.on :press, @control_map["place_tile"] do
              if @model.selection_stage == 1
                @view.tileselection_rect.tile_rect.xyz = @model.map_cursor.position

                @view.tileselection_rect.activate
                @model.selection_stage += 1
              elsif @model.selection_stage == 2
                @view.tileselection_rect.tile_rect.whd = @model.map_cursor.position - @view.tileselection_rect.tile_rect.xyz

                id = @model.map.chunks.size+1
                new_chunk @view.tileselection_rect.tile_rect,
                          id: id, name: "New Chunk #{id}", uri: "/chunks/new/chunk-#{id}"
                create_tilemaps

                @model.selection_stage = 0
                @view.tileselection_rect.deactivate
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
                @model.selection_stage -= 1
                @tileselection_rect.deactivate
              end
            end
          end

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
              @controller.select_tile(Input::Mouse.pos-[0,16])
            end
          end

          input.on :press, @control_map["enter_view_mode"] do
            @mode.change :view
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

        modespace :view do |input|
          ## mode toggle
          input.on :press, @control_map["enter_edit_mode"] do
            @mode.change :edit
          end
        end
      end

      def switch_mode_icon(mode)
        time = "150"
        @scheduler.in time do
          add_transition @mode_icon_color, Vector4.new(1, 1, 1, 1), time do |value|
            @mode_icon_color = value
          end
          @mode_icon = case mode
                       when :view then "film"
                       when :edit then "gear"
                       when :help then "book"
                       else
                         @mode_icon
                       #when :help then "book"
                       end
        end
        add_transition @mode_icon_color, Vector4.new(0, 0, 0, 0), time do |value|
          @mode_icon_color = value
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
        if @mode.is?(:edit)
          @controller.update_edit_mode(delta)
        end
        update_world(delta)
        super delta
      end

      def render_map
        pos = -@model.camera.view.floor
        @chunk_renderers.each do |renderer|
          renderer.render(*pos)
        end
      end

      def render_mode_icon
        @font_awesome.render(@mode_icon_rect.x,
                             @mode_icon_rect.y,
                             0,
                             @charmap_awesome[@mode_icon],
                             @mode_icon_color)
      end

      def render
        render_map
        if @mode.is? :help
          @view.render_help_mode
        elsif @mode.has? :edit
          @view.render_edit_mode
        end
        render_mode_icon
        super
      end
    end
  end
end
