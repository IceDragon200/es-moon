module ES
  module States
    class Map < State

      def init
        super
        create_camera

        create_tilemap
        create_entity
        create_debug_objects

        @entity.moveto(1, 1)

        @controller = ES::Controller::Entity.new(@entity)
        @cam_controller = ES::Controller::Camera.new(@camera)

        @ui_posmon.set_obj(@entity, true)
        @ui_camera_posmon.set_obj(@camera, true)

        @camera.follow(@entity)
      end

      def create_camera
        @camera = Camera2.new
      end

      def create_tilemap
        @map_pos = Vector3.new 0, 0, 0
        @tilemap = Tilemap.new do |tilemap|
          chunk = ES::Database.find :chunk, name: "school_f1/baron.room"

          filename = "oryx_lofi_fantasy/4x/lofi_environment_4x.png"

          tilemap.tileset = Cache.tileset filename, 32, 32
          tilemap.data = chunk.data
          tilemap.flags = chunk.flags
        end
      end

      def create_entity
        @entity = ES::GData::Actor.new
        filename = "oryx_lofi_fantasy/3x/lofi_char_3x.png"
        @entity_sp = Cache.tileset filename, 24, 24
        @entity_voffset =
          Vector3.new @tilemap.tileset.cell_width - @entity_sp.cell_width,
                      @tilemap.tileset.cell_height - @entity_sp.cell_height,
                      0
        @entity_voffset /= 2
      end

      def create_debug_objects
        @ui_posmon = ES::UI::PositionMonitor.new
        @ui_camera_posmon = ES::UI::PositionMonitor.new
      end

      def update
        @controller.update
        @cam_controller.update

        @camera.update

        @ui_posmon.update
        @ui_camera_posmon.update
        super
      end

      def render
        pos = @map_pos - @camera.view_xy.xyz
        charpos = pos + (@entity.position * 32) + @entity_voffset
        @tilemap.render(*pos)
        @entity_sp.render(*charpos, 0)

        # debug
        h = Moon::Screen.height - @ui_posmon.height
        @ui_posmon.render((Moon::Screen.width - @ui_posmon.width) / 2, h, 0)
        @ui_camera_posmon.render((Moon::Screen.width - @ui_camera_posmon.width) / 2,
                                  Moon::Screen.height - @ui_camera_posmon.height - h, 0)
        super
      end

    end
  end
end