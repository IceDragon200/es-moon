module States
  class MapViewer < Base
    def init
      super
      @control_map = DataCache.controlmap('map_editor')
      @camera = Camera2.new(view: engine.screen.rect)
      @camera_cursor = CameraCursor.new
      @camera.follow(@camera_cursor)

      setup_state_events
      setup_camera_events
      create_map
      create_spriteset

      @updatables << @camera
      @updatables << @camera_cursor
    end

    def setup_state_events
      input.on :press, :escape do
        state_manager.pop
      end
    end

    def set_camera_velocity(x, y)
      @camera_cursor.velocity.x = x if x
      @camera_cursor.velocity.y = y if y
    end

    def setup_camera_events
      d = 8
      input.on :press, @control_map['move_camera_left'] do
        set_camera_velocity(-d, nil)
      end

      input.on :press, @control_map['move_camera_right'] do
        set_camera_velocity(d, nil)
      end

      input.on :release, @control_map['move_camera_left'], @control_map['move_camera_right'] do
        set_camera_velocity(0, nil)
      end

      input.on :press, @control_map['move_camera_up'] do
        set_camera_velocity(nil, -d)
      end

      input.on :press, @control_map['move_camera_down'] do
        set_camera_velocity(nil, d)
      end

      input.on :release, @control_map['move_camera_up'], @control_map['move_camera_down'] do
        set_camera_velocity(nil, 0)
      end
    end

    def create_map
      @editor_map = Dataman.load_editor_map(uri: '/maps/school/f1')
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
        element.enable_mouseinside
        element.on :mouseinside do |e|
          element.show_border = e.inside
          element.show_label = e.inside
        end
      end

      @renderer.add @map_renderer
    end
  end
end
