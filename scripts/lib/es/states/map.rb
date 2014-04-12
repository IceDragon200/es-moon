module ES
  module States
    class Map < State

      def init
        super
        create_map

        create_camera

        create_tilemaps
        create_entity
        #create_particles

        create_debug_objects

        @entity.moveto(1, 1)

        @controller = ES::Controller::Entity.new(@entity)
        @cam_controller = ES::Controller::Camera.new(@camera)

        @ui_posmon.set_obj(@entity, true)
        @ui_camera_posmon.set_obj(@camera, true)

        @camera.follow(@entity)
      end

      def create_map
        @map = ES::GData::Map.new
        @map.setup(Database.find :map, name: "school_f1")
      end

      def create_camera
        @camera = Camera2.new
      end

      def create_tilemaps
        @map_pos = Vector3.new 0, 0, 0

        filename = "oryx_lofi_fantasy/4x/lofi_environment_4x.png"
        @tileset = Cache.tileset filename, 32, 32

        @tilemaps = @map.visible_chunks.map do |chunk|
          Tilemap.new do |tilemap|
            tilemap.position.set(*(chunk.position * 32))
            tilemap.tileset = @tileset
            tilemap.data = chunk.data
            tilemap.flags = chunk.flags
          end
        end
      end

      def create_entity
        @entity = ES::GData::Actor.new
        filename = "oryx_lofi_fantasy/3x/lofi_char_3x.png"
        @entity_sp = Cache.tileset filename, 24, 24
        @entity_voffset =
          Vector3.new @tileset.cell_width - @entity_sp.cell_width,
                      @tileset.cell_height - @entity_sp.cell_height,
                      0
        @entity_voffset /= 2
      end

      def create_particles
        filename = "oryx_lofi_fantasy/lofi_obj.png"
        spritesheet = Cache.tileset filename, 8, 8
        @particles = ParticleSystem.new(spritesheet)
        @particles.ticks = 30

        device = Moon::Input::Keyboard
        @spawn = InputHandle.new(device, device::Keys::SPACE)
      end

      def create_debug_objects
        @ui_posmon = ES::UI::PositionMonitor.new
        @ui_camera_posmon = ES::UI::PositionMonitor.new
      end

      def update_particles
        if @spawn.held?
          x = (rand * 2.0) / 8.0
          y = (rand * 2.0) / 8.0
          x = -x if rand(2) == 0

          @particles.add(
            cell_index: 137,
            position: @entity.position * 32,
            accel: [x, y, 0.0],
            velocity: [0.0, -2.0, 0.0]
          )
        end

        @particles.update
      end

      def update
        @controller.update
        @cam_controller.update

        #update_particles

        @camera.update

        @ui_posmon.update
        @ui_camera_posmon.update
        super
      end

      def render
        pos = (@map_pos - @camera.view_xy.xyz).round
        charpos = (pos + (@entity.position * 32) + @entity_voffset).round
        @tilemaps.each do |tilemap|
          tilemap.render(*pos)
        end
        @entity_sp.render(*charpos, 0)

        #@particles.render(*pos)

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