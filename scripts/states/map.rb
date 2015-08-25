module States
  class Map < Base
    def init
      super
    end

    def start
      super
      @map = ES::Map.find_by(uri: '/maps/school/f1')

      @world = ES::EntitySystem::World.new(game)
      @world.register :map_rendering

      @world.spawn do |entity|
        entity.add map: { map: @map }
      end
    end

    def update(delta)
      @world.update delta
      super
    end

    def render
      @world.render
      super
    end
  end
end
