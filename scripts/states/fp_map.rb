module States
  class FpMap < Base
    def init
      super
      create_world
      create_map
      create_entity

      create_camera

      @camera.follow EntityPositionAdapter.new(@entity)

      create_spriteset

      #@pss_sprite8x = Moon::sprite.new('resources/blocks/e008x008.png', 8, 8)
      #@pss_sprite = Moon::sprite.new('resources/blocks/e032x032.png', 32, 32)
      register_actor_move

      @transform = Moon::Transform.new
    end

    def register_actor_move
      move_distance = 0.1
      input.on :press, :mouse_right do |e|
        screen_position = e.position.to_vec3
        world_position = @camera.screen_to_world(screen_position)
        target = @world.entities.find do |entity|
          entity != @entity &&
          (sprite = entity[:sprite]) &&
          sprite.bounds.contains?(screen_position)
        end
        if target
          @entity.comp(:target) do |t|
            t.target = target
          end
        else
          @entity.comp(:navigation) do |navi|
            navi.destination = world_position
          end
        end
      end
    end

    def create_world
      @world = ES::EntitySystem::World.new
      @template_world = ES::EntitySystem::World.new
      @world.register :movement
      @world.register :thinks
      @world.register :spawning

      @world.on :any do |e|
        @spriteset_map.trigger(e) if @spriteset_map
      end

      @update_list << @world
      @render_list << @world
    end

    def create_map
      @map = Dataman.load_editor_map(uri: '/maps/school/f1')
    end

    def create_entity
      @entity = @world.spawn do |entity|
        entity.add(transform: { position: Moon::Vector3.new },
                   navigation: { destination: Moon::Vector3.new },
                   body: { speed: 4.0 },
                   health: { value: 100, max: 100 },
                   team: { number: Team::ALLY },
                   sprite: {},
                   target: {})
      end

      template = @template_world.spawn do |entity|
        entity.add(transform: { position: Moon::Vector3.new },
                   navigation: { destination: Moon::Vector3.new },
                   body: { speed: 2.0 },
                   health: { value: 100, max: 100 },
                   team: { number: Team::ENEMY },
                   brain: {},
                   sprite: {},
                   target: {})
      end

      @spawner = @world.spawn do |entity|
        entity.add(transform: { position: Moon::Vector3.new(@map.w.to_i / 2, @map.h.to_i / 2, 0) },
                   spawner: { template: template, timer: Moon::Timer.new(duration: '3s') })
      end
    end

    def create_camera
      @camera = Camera2.new
    end

    def create_spriteset
      @spriteset_map = SpritesetMap.new
      @spriteset_map.world = @world
      @spriteset_map.dm_map = @map
      @spriteset_map.tilesize = @camera.tilesize

      @renderer.add @spriteset_map
    end

    def post_update(delta)
      @camera.update delta

      campos = -@camera.view_offset.floor
      @spriteset_map.position = campos
      super
    end
  end
end
