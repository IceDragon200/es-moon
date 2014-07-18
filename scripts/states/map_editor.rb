require "scripts/states/map_editor/controller"
require "scripts/states/map_editor/model"
require "scripts/states/map_editor/view"
require "scripts/states/map_editor/mode_stack"

module ES
  module States
    class MapEditor < Base
      def init
        super
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
        @input.on :press, :left do
          @model.cam_cursor.velocity.x = -1 * @cam_move_speed
        end
        @input.on :press, :right do
          @model.cam_cursor.velocity.x = 1 * @cam_move_speed
        end
        @input.on :release, :left, :right do
          @model.cam_cursor.velocity.x = 0
        end

        @input.on :press, :up do
          @model.cam_cursor.velocity.y = -1 * @cam_move_speed
        end
        @input.on :press, :down do
          @model.cam_cursor.velocity.y = 1 * @cam_move_speed
        end
        @input.on :release, :up, :down do
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
          input.on :press, :n0 do
            @controller.zoom_reset
          end

          input.on :press, :minus do
            @controller.zoom_out
          end

          input.on :press, :equal do
            @controller.zoom_in
          end

          ## copy tile
          input.on :press, :mouse_middle do
            @controller.copy_tile
          end

          ## erase tile
          input.on :press, :mouse_right do
            @controller.erase_tile
          end

          ## help
          input.on :press, :f1 do
            @mode.push :help
            @controller.show_help
          end

          modespace :help do |inp2|
            inp2.on :release, :f1 do
              @mode.pop
              @controller.hide_help
            end
          end

          ## New Map
          input.on :press, Moon::Input::F2 do
            @controller.new_map
            @mode.push :new_map
          end

          modespace :new_map do |inp2|
            inp2.on :release, Moon::Input::F2 do
              @controller.on_new_map_release
              @mode.pop
            end
          end

          ## New Chunk
          input.on :press, Moon::Input::F3 do
            @mode.push :new_chunk
            @controller.new_chunk
          end

          @selection_stage = 0
          modespace :new_chunk do |inp2|
            inp2.on :press, :mouse_left do
              if @selection_stage == 1
                @view.tileselection_rect.tile_rect.xyz = @model.map_cursor.position

                @view.tileselection_rect.activate
                @selection_stage += 1
              elsif @selection_stage == 2
                @view.tileselection_rect.tile_rect.whd = @model.map_cursor.position - @view.tileselection_rect.tile_rect.xyz

                id = @model.map.chunks.size+1
                new_chunk @view.tileselection_rect.tile_rect,
                          id: id, name: "New Chunk #{id}", uri: "/chunks/new/chunk-#{id}"
                create_tilemaps

                @selection_stage = 0
                @view.tileselection_rect.deactivate
                @view.dashboard.disable 2
                @mode.pop
                @view.notifications.clear
              end
            end
            inp2.on :press, :mouse_right do
              if @view.selection_stage == 1
                @view.selection_stage = 0
                @dashboard.disable 2
                @mode.pop
                @view.notifications.clear
              elsif @selection_stage == 2
                @selection_stage -= 1
                @tileselection_rect.deactivate
              end
            end
          end

          input.on :press, :f5 do
            @controller.save_map
          end

          input.on :release, :f5 do
            @controller.on_save_map_release
          end

          input.on :press, :f6 do
            @controller.load_chunks
          end

          input.on :release, :f6 do
            @controller.on_load_chunks_release
          end

          ## Show Chunk Labels
          input.on :press, :f10 do
            @controller.show_chunk_labels
            @controller.hide_tile_info
            @mode.push :show_chunk_labels
          end

          modespace :show_chunk_labels do |inp2|
            inp2.on :release, :f10 do
              @controller.hide_chunk_labels
              @controller.show_tile_info
              @mode.pop
            end
          end

          ## tile panel
          input.on :press, :tab do
            @mode.push :tile_select
            @controller.show_tile_panel
            @controller.hide_tile_preview
          end

          modespace :tile_select do |inp2|
            inp2.on :release, :tab do
              @mode.pop
              @controller.hide_tile_panel
              @controller.show_tile_preview
            end
            inp2.on :press, :mouse_left do
              @controller.select_tile(Input::Mouse.pos-[0,16])
            end
          end

          input.on :press, :mouse_left do
            @controller.place_current_tile
          end

          input.on :press, :v do
            @mode.change :view
          end

          ## layer toggle
          input.on :press, :grave_accent do
            @controller.set_layer(-1)
          end
          input.on :press, :n1 do
            @controller.set_layer(0)
          end
          input.on :press, :n2 do
            @controller.set_layer(1)
          end
        end

        modespace :view do |input|
          ## mode toggle
          input.on :press, :e do
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
