require 'scripts/ui/map_list'

module States
  class MapViewer < Base
    def init
      super
      view = screen.rect
      view = view.translate(-view.w / 2, -view.h / 2)
      @camera = Camera2.new(view: view)
      @camera_cursor = CameraCursor2.new
      @camera.follow(@camera_cursor)

      @update_list << @camera
      @update_list << @camera_cursor
    end

    def start
      super
      @control_map = game.database['controlmaps/map_editor']

      @map_list = UI::MapList.new
      @map_list.position.set(16, 16, 0)
      @gui.add @map_list

      create_spriteset
      setup_camera_events
      setup_state_events
      setup_map_events

      setup_map
      show_map_list
    end

    def on_map_selected(map)
      @map = @map_renderer.map = map
      @camera_cursor.position.set(map.bounds.cx, map.bounds.cy)
    end

    def hide_map_list
      @camera_cursor.activate
      @map_list.deactivate.hide
    end

    def show_map_list
      @camera_cursor.deactivate
      old_map = @map
      @map_list.refresh_list.activate.show.jump_to_item(map_id: old_map.id)
    end

    def setup_state_events
      input.on :press do |e|
        if e.key == :escape
          if @map_list.active?
            state_manager.pop
          else
            show_map_list
          end
        end
      end
    end

    def set_camera_velocity(x, y)
      @camera_cursor.velocity.x = x if x
      @camera_cursor.velocity.y = y if y
    end

    def setup_camera_events
      d = 16
      key_handle = lambda do |*a, &b|
        keys = a.map(&:to_sym)
        proc do |e, elm|
          b.call(e, elm) if keys.include?(e.key)
        end
      end

      control_handle = lambda do |*names, &b|
        keys = names.map { |name| @control_map[name] }.flatten
        key_handle.call(*keys, &b)
      end

      input.on :press, &(control_handle.call('move_camera_left') do
        set_camera_velocity(-d, nil)
      end)

      input.on :press, &(control_handle.call('move_camera_right') do
        set_camera_velocity(d, nil)
      end)

      input.on :release, &(control_handle.call('move_camera_left', 'move_camera_right') do
        set_camera_velocity(0, nil)
      end)

      input.on :press, &(control_handle.call('move_camera_up') do
        set_camera_velocity(nil, -d)
      end)

      input.on :press, &(control_handle.call('move_camera_down') do
        set_camera_velocity(nil, d)
      end)

      input.on :release, &(control_handle.call('move_camera_up', 'move_camera_down') do
        set_camera_velocity(nil, 0)
      end)
    end

    def setup_map
      on_map_selected game.database[game.database['system']['starting_map']]
    end

    def create_spriteset
      @map_renderer = Renderers::EditorMap.new
      @map_renderer.show_borders  = true
      @map_renderer.show_labels   = true
      @map_renderer.show_underlay = true
      @map_renderer.show_overlay  = nil
      @map_renderer.map = @map
      @map_renderer.camera = @camera
      @renderer.add @map_renderer
    end

    def setup_map_events
      @map_list.on :ok do
        hide_map_list
      end

      @map_list.on :map_selected do |e|
        on_map_selected(e.map)
      end
    end
  end
end
