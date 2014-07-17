module ES
  module States
    class Map < Base
      def init
        super
        create_world
        create_map
        create_entity

        create_camera

        create_tilemaps
        create_entity_sprite

        @camera.follow(EntityPositionAdaptor.new(@entity))

        #@pss_spritesheet8x = Moon::Spritesheet.new("resources/blocks/e008x008.png", 8, 8)
        #@pss_spritesheet = Moon::Spritesheet.new("resources/blocks/e032x032.png", 32, 32)
        register_actor_move

        @transform = Transform.new
      end

      def register_actor_move
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

      def create_world
        @world = World.new
        @world.register(:movement)
      end

      def create_map
        @map = ES::GameObject::Map.new
        @map.setup(Database.find :map, name: "school_f1")
      end

      def create_entity
        @entity = @world.spawn
        @map.entities.push @entity
      end

      def create_camera
        @camera = Camera2.new
      end

      def create_tilemaps
        filename = "oryx_lofi_fantasy/4x/lofi_environment_4x.png"
        @tileset = ES.cache.tileset filename, 32, 32

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
        @entity_sp = ES.cache.tileset filename, 24, 24
        @entity_voffset =
          Vector3.new @tileset.cell_width - @entity_sp.cell_width,
                      @tileset.cell_height - @entity_sp.cell_height,
                      0
        @entity_voffset /= 2
      end

      def update_map(delta)
        @map.update delta

        @camera.update delta
      end

      def update(delta)
        update_map delta

        super delta
      end

      def render
        campos = -@camera.view.floor
        charpos = @entity[:position]
        charpos = (campos + (Vector3[charpos.x, charpos.y, 0] * 32) + @entity_voffset).floor

        @tilemaps.each do |tilemap|
          tilemap.render(*campos, transform: @transform)
        end
        @entity_sp.render(*charpos, 0, transform: @transform)
        super
      end
    end
  end
end
