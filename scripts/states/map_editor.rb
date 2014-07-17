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

        @transform_transition = nil
      end

      def create_world
        @world = World.new
      end

      def create_map
        map = Database.find(:map, uri: "/maps/school/f1")
        @model.map = map.to_editor_map
        @model.map.chunks = map.chunks.map do |chunk_head|
          editor_chunk = Database.find(:chunk, uri: chunk_head.uri).to_editor_chunk
          editor_chunk.position = chunk_head.position
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
            @notifications.notify string: "Help"
          end

          modespace :help do |inp2|
            inp2.on :release, :f1 do
              @mode.pop
              @controller.hide_help
              @notifications.clear
            end
          end

          ## New Map
          input.on :press, Moon::Input::F2 do
            @dashboard.enable 1
            @mode.push :create_map
            @notifications.notify string: "Create Map"
          end

          modespace :create_map do |inp2|
            inp2.on :release, Moon::Input::F2 do
              @dashboard.disable 1
              @mode.pop
              @notifications.clear
            end
          end

          ## New Chunk
          input.on :press, Moon::Input::F3 do
            @dashboard.enable 2
            @mode.push :create_chunk
            @selection_stage = 1
            @notifications.notify string: "Create Chunk"
          end

          @selection_stage = 0
          modespace :create_chunk do |inp2|
            inp2.on :press, Moon::Input::MOUSE_LEFT do
              if @selection_stage == 1
                @tileselection_rect.tile_rect.xyz = @model.map_cursor.position

                @tileselection_rect.activate
                @selection_stage += 1
              elsif @selection_stage == 2
                @tileselection_rect.tile_rect.whd = @model.map_cursor.position - @tileselection_rect.tile_rect.xyz

                id = @model.map.chunks.size+1
                create_chunk @tileselection_rect.tile_rect, id: id, name: "new/chunk-#{id}"
                create_tilemaps

                @selection_stage = 0
                @tileselection_rect.deactivate
                @dashboard.disable 2
                @mode.pop
                @notifications.clear
              end
            end
            inp2.on :press, Moon::Input::MOUSE_RIGHT do
              if @selection_stage == 1
                @selection_stage = 0
                @dashboard.disable 2
                @mode.pop
                @notifications.clear
              elsif @selection_stage == 2
                @selection_stage -= 1
                @tileselection_rect.deactivate
              end
            end
          end

          input.on :press, Moon::Input::F5 do
            @dashboard.ok 4
            @controller.save_map
            @notifications.notify string: "Saved"
          end

          input.on :release, Moon::Input::F5 do
            @dashboard.disable 4
          end

          input.on :press, Moon::Input::F6 do
            @dashboard.ok 5
            @notifications.notify string: "Loading ..."
          end

          input.on :release, Moon::Input::F6 do
            @dashboard.disable 5
          end

          ## Show Chunk Labels
          input.on :press, Moon::Input::F10 do
            @dashboard.enable 9
            @model.flag_show_chunk_labels = true
            @mode.push :show_chunk_labels
            @controller.hide_tile_info
          end

          modespace :show_chunk_labels do |inp2|
            inp2.on :release, Moon::Input::F10 do
              @dashboard.disable 9
              @model.flag_show_chunk_labels = false
              @controller.show_tile_info
              @mode.pop
            end
          end

          ## tile panel
          input.on :press, Moon::Input::TAB do
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
          case mode
          when :view
            @mode_icon = "film"
          when :edit
            @mode_icon = "gear"
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
          @help_panel.render
        elsif @mode.has? :edit
          @view.render_edit_mode
        end
        render_mode_icon
        super
      end
    end
  end
end
