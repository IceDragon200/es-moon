require "scripts/es/states/map_editor/controller"
require "scripts/es/states/map_editor/model"
require "scripts/es/states/map_editor/view"
require "scripts/es/states/map_editor/mode_stack"

module ES
  module States
    class MapEditor < Map

      def init
        @model = MapEditorModel.new
        super
        @view = MapEditorView.new
        @controller = MapEditorController.new @model, @view

        @mode = ModeStack.new
        @mode.push :view

        create_autosave_interval

        @controller.set_layer(-1)

        register_events

        @transform_transition = nil
      end

      def create_tilemaps
        super
        @tilemaps.each { |t| t.layer_opacity = @model.layer_opacity }
      end

      def create_autosave_interval
        @autosave_interval = add_interval(60 * 3) do
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
        @input.on :press, Moon::Input::LEFT do
          @cam_cursor.velocity.x = -1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :press, Moon::Input::RIGHT do
          @cam_cursor.velocity.x = 1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :release, Moon::Input::LEFT, Moon::Input::RIGHT do
          @cam_cursor.velocity.x = 0 if @mode.starts_with? :edit
        end

        @input.on :press, Moon::Input::UP do
          @cam_cursor.velocity.y = -1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :press, Moon::Input::DOWN do
          @cam_cursor.velocity.y = 1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :release, Moon::Input::UP, Moon::Input::DOWN do
          @cam_cursor.velocity.y = 0 if @mode.starts_with? :edit
        end
      end

      def register_events
        modespace :edit do |input|
          input.on :press, Moon::Input::N0 do
            @controller.zoom_reset
          end

          input.on :press, Moon::Input::MINUS do
            @controller.zoom_out
          end

          input.on :press, Moon::Input::EQUAL do
            @controller.zoom_in
          end

          ## copy tile
          input.on :press, Moon::Input::MOUSE_MIDDLE do
            @controller.copy_tile
          end

          ## erase tile
          input.on :press, Moon::Input::MOUSE_RIGHT do
            @controller.erase_tile
          end

          ## help
          input.on :press, Moon::Input::F1 do
            @dashboard.enable 0
            @mode.push :help
            @notifications.notify string: "Help"
          end

          modespace :help do |inp2|
            inp2.on :release, Moon::Input::F1 do
              @dashboard.disable 0
              @mode.pop
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
                @tileselection_rect.tile_rect.xyz = @cursor_position_map_pos

                @tileselection_rect.activate
                @selection_stage += 1
              elsif @selection_stage == 2
                @tileselection_rect.tile_rect.whd = @cursor_position_map_pos - @tileselection_rect.tile_rect.xyz

                id = @map.chunks.size+1
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
            @mode.push :show_chunk_labels
            @tile_info.hide
          end

          modespace :show_chunk_labels do |inp2|
            inp2.on :release, Moon::Input::F10 do
              @dashboard.disable 9
              @tile_info.show
              @mode.pop
            end
          end

          ## tile panel
          input.on :press, Moon::Input::TAB do
            @mode.push :tile_select
            @tile_panel.show
            @tile_preview.hide
          end

          modespace :tile_select do |inp2|
            inp2.on :release, Moon::Input::TAB do
              @mode.pop
              @tile_panel.hide
              @tile_preview.show
            end
            inp2.on :press, Moon::Input::MOUSE_LEFT do
              @tile_panel.select_tile(Mouse.pos-[0,16])
            end
          end

          input.on :press, Moon::Input::MOUSE_LEFT do
            @controller.place_tile @tile_panel.tile_id
          end

          input.on :press, Moon::Input::V do
            @mode.change :view
            @camera.follow @entity
            @view.ui_posmon.obj = @entity
          end

          ## layer toggle
          input.on :press, Moon::Input::GRAVE_ACCENT do
            @controller.set_layer(-1)
          end
          input.on :press, Moon::Input::N1 do
            @controller.set_layer(0)
          end
          input.on :press, Moon::Input::N2 do
            @controller.set_layer(1)
          end
        end
        modespace :view do |input|
          ## mode toggle
          input.on :press, Moon::Input::E do
            @camera.follow @cam_cursor
            @view.ui_posmon.obj = @cam_cursor
            @mode.change :edit
          end

          input.on :press, Moon::Input::LEFT do
            @entity.velocity.x = -1 * @entity.move_speed
          end
          input.on :press, Moon::Input::RIGHT do
            @entity.velocity.x = 1 * @entity.move_speed
          end
          input.on :release, Moon::Input::LEFT, Moon::Input::RIGHT do
            @entity.velocity.x = 0
          end

          input.on :press, Moon::Input::UP do
            @entity.velocity.y = -1 * @entity.move_speed
          end
          input.on :press, Moon::Input::DOWN do
            @entity.velocity.y = 1 * @entity.move_speed
          end
          input.on :release, Moon::Input::UP, Moon::Input::DOWN do
            @entity.velocity.y = 0
          end
        end
      end

      def update_map(delta)
        return if @mode.is? :help
        super delta
      end

      def update(delta)
        @controller.update delta
        super delta
      end

      def render
        super
        if @mode.is? :help
          @help_panel.render
        elsif @mode.has? :edit
          @view.render_edit_mode
        end
      end

    end
  end
end
