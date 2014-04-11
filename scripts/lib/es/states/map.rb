module ES
  module States
    class Map < State

      def init
        super
        create_camera

        create_tilemap
        create_character
        create_debug_objects

        @controller = ES::Controller::Character.new(@character)

        @ui_posmon.set_obj(@character, true)
        @ui_camera_posmon.set_obj(@camera, true)
      end

      def create_camera
        @camera = Camera2.new
      end

      def create_tilemap
        @map_pos = Vector3.new 0, 0, 0
        @tilemap = Tilemap.new do |tilemap|
          chunk = ES::Database.find :chunk, name: "school_f1/baron.room"
          #filename = "tileset_16x16_Jerom_CC-BY-SA-3.0_8_blue.png"
          filename = "oryx_lofi_fantasy/4x/lofi_environment_4x.png"
          tilemap.tileset = Cache.tileset filename, 32, 32
          #tilemap.tileset = Cache.tileset("ass_file_tran_16x24.png", 16, 24)
          tilemap.data = chunk.data
          tilemap.flags = chunk.flags
        end
      end

      def create_character
        @character = ES::GData::Character.new
        filename = "oryx_lofi_fantasy/3x/lofi_char_3x.png"
        @character_sp = Cache.tileset filename, 24, 24
        @character_voffset =
          Vector3.new @tilemap.tileset.cell_width - @character_sp.cell_width,
                      @tilemap.tileset.cell_height - @character_sp.cell_height,
                      0
        @character_voffset /= 2
      end

      def create_debug_objects
        @ui_posmon = ES::UI::PositionMonitor.new
        @ui_camera_posmon = ES::UI::PositionMonitor.new
      end

      def update
        @controller.update

        @ui_posmon.update
        @ui_camera_posmon.update
        super
      end

      def render
        pos = @map_pos - @camera.position.xyz
        charpos = pos + (@character.position * 32) + @character_voffset
        @tilemap.render(*pos)
        @character_sp.render(*charpos, 0)

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