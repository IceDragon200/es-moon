module ES
  module States
    class Map < State

      def init
        super
        create_map
        create_entity

        create_camera

        create_tilemaps
        create_entity_sprite
        #create_particles

        create_debug_objects

        @entity.moveto(1, 1)

        @ui_posmon.set_obj(@entity, true)
        @ui_camera_posmon.set_obj(@camera, true)

        @camera.follow(@entity)

        #@pss_spritesheet8x = Moon::Spritesheet.new("resources/blocks/e008x008.png", 8, 8)
        #@pss_spritesheet = Moon::Spritesheet.new("resources/blocks/e032x032.png", 32, 32)

        @input.on :press, Moon::Input::LEFT do
          @entity.velocity.x = -1 * @entity.move_speed
        end
        @input.on :press, Moon::Input::RIGHT do
          @entity.velocity.x = 1 * @entity.move_speed
        end
        @input.on :release, Moon::Input::LEFT, Moon::Input::RIGHT do
          @entity.velocity.x = 0
        end

        @input.on :press, Moon::Input::UP do
          @entity.velocity.y = -1 * @entity.move_speed
        end
        @input.on :press, Moon::Input::DOWN do
          @entity.velocity.y = 1 * @entity.move_speed
        end
        @input.on :release, Moon::Input::UP, Moon::Input::DOWN do
          @entity.velocity.y = 0
        end
      end

      def create_map
        @map = ES::GameObject::Map.new
        @map.setup(Database.find :map, name: "school_f1")
      end

      def create_entity
        @entity = ES::GameObject::Actor.new
        @map.entities.push @entity
      end

      def create_camera
        @camera = Camera2.new
      end

      def create_tilemaps
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

      def create_entity_sprite
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

      def update_map
        @map.update

        #update_particles
        @camera.update

        @ui_posmon.update
        @ui_camera_posmon.update
      end

      def update
        update_map

        super
      end

      ###
      # @param [Vector3] screen_pos
      ###
      def screen_pos_to_map_pos(screen_pos)
        campos = @camera.view.floor
        pos = screen_pos + campos
        pos / 32
      end

      def render
        campos = -@camera.view.floor
        charpos = (campos + (@entity.position * 32) + @entity_voffset).floor

        @tilemaps.each do |tilemap|
          tilemap.render(*campos)
        end
        @entity_sp.render(*charpos, 0)

        #rad = Math::PI * 2 * ((@ticks % 120) / 120.0)
        #rad = (Moon::Input::Mouse.pos - charpos.xy).rad
        #sqpos = Vector2[32, 0].rotate(rad).xyz + @entity_voffset
        #@pss_spritesheet8x.render(*(charpos + sqpos), 1)

        ##
        # Passage debug
        #chp = @entity.position
        #x = chp.x.round
        #y = chp.y.round
        #x2 = x - 1
        #y2 = y - 1
        #x3 = x + 1
        #y3 = y + 1
        #@pss_spritesheet.render(campos.x + x * 32, campos.y + y  *  32, 0,
        #                        @map.passages[x, y] == ES::Passage::NONE ? 2 : 1)
        #@pss_spritesheet.render(campos.x + x * 32, campos.y + y2 *  32, 0,
        #                        @map.passages[x, y2] == ES::Passage::NONE ? 8 : 9)
        #@pss_spritesheet.render(campos.x + x * 32, campos.y + y3 *  32, 0,
        #                        @map.passages[x, y3] == ES::Passage::NONE ? 8 : 9)
        #@pss_spritesheet.render(campos.x + x2 * 32, campos.y + y *  32, 0,
        #                        @map.passages[x2, y] == ES::Passage::NONE ? 8 : 9)
        #@pss_spritesheet.render(campos.x + x2 * 32, campos.y + y2 * 32, 0,
        #                        @map.passages[x2, y2] == ES::Passage::NONE ? 8 : 9)
        #@pss_spritesheet.render(campos.x + x2 * 32, campos.y + y3 * 32, 0,
        #                        @map.passages[x2, y3] == ES::Passage::NONE ? 8 : 9)
        #@pss_spritesheet.render(campos.x + x3 * 32, campos.y + y *  32, 0,
        #                        @map.passages[x3, y] == ES::Passage::NONE ? 8 : 9)
        #@pss_spritesheet.render(campos.x + x3 * 32, campos.y + y2 * 32, 0,
        #                        @map.passages[x3, y2] == ES::Passage::NONE ? 8 : 9)
        #@pss_spritesheet.render(campos.x + x3 * 32, campos.y + y3 * 32, 0,
        #                        @map.passages[x3, y3] == ES::Passage::NONE ? 8 : 9)

        #@particles.render(*campos)

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