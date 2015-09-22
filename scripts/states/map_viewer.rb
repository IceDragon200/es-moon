module States
  class MapViewer < Base
    def init
      super
      view = screen.rect
      view = view.translate(-view.w / 2, -view.h / 2)
      @control_map = game.database['controlmaps/map_editor']
      @camera = Camera2.new(view: view)
      @camera_cursor = CameraCursor2.new
      @camera.follow(@camera_cursor)

      setup_state_events
      setup_camera_events
      create_map
      create_spriteset

      @update_list << @camera
      @update_list << @camera_cursor
    end

    def setup_state_events
      input.on :press do |e|
        state_manager.pop if e.key == :escape
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

    def create_map
      @editor_map = game.database['maps/school/f1']
    end

    def create_spriteset
      @map_renderer = EditorMapRenderer.new
      @map_renderer.show_borders  = nil
      @map_renderer.show_labels   = nil
      @map_renderer.show_underlay = true
      @map_renderer.show_overlay  = nil
      @map_renderer.dm_map = @editor_map
      @map_renderer.camera = @camera
      @map_renderer.each do |element|
        element.enable_default_events
        element.border_renderer.animate = true
        element.on :mousehover do |e|
          element.show_border = e.state
          element.show_label = e.state
        end

        element.on :click do |e|
          @camera_cursor.moveto element.chunk.position + (Moon::Vector3[element.chunk.w, element.chunk.h, 0] / 2)
        end
      end

      @renderer.add @map_renderer
    end
  end
end
