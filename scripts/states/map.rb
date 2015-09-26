module States
  class Map < Base
    def start
      super
      @map = game.database[game.database['system']['starting_map']]

      @world = ES::EntitySystem::World.new(game)
      @world.register :movement

      @world.register :transfer
      @world.register :map

      @world.register :map_rendering
      @world.register :rendering

      @world.spawn do |entity|
        entity.add level: { map: @map }
      end

      @player = @world.spawn do |entity|
        entity.add :player
        entity.add sprite: { filename: 'characters/4x/characters_4x', type: 'spritesheet', cell_w: 32, cell_h: 32, index: 1 }
        entity.add mapobj: { map_id: @map.id, position: Moon::Vector2[1, 1] }
        entity.add :transfer
        entity.add :movement
        entity.add :transform
      end

      input.on :press do |e|
        m = @player[:movement]
        case e.key
        when :up    then m.vect.y = -1
        when :down  then m.vect.y = 1
        when :left  then m.vect.x = -1
        when :right then m.vect.x = 1
        end
      end

      input.on :release do |e|
        m = @player[:movement]
        case e.key
        when :up    then m.vect.y = 0
        when :down  then m.vect.y = 0
        when :left  then m.vect.x = 0
        when :right then m.vect.x = 0
        end
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
