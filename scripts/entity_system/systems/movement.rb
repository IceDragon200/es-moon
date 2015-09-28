require 'scripts/entity_system/system'
require 'scripts/entity_system/system/processing'
require 'scripts/entity_system/components/transform'
require 'scripts/entity_system/components/movement'
require 'scripts/entity_system/components/body'

module Systems
  # The movement system is responsible for collision handling and moving
  # entities in a fixed direction based on a vector.
  # This system can also mark entities for transfer by reading the map zones
  class Movement < Base
    register :movement

    def post_initialize
      super
      @map_cache = {}
    end

    # Callback after an entity has moved
    #
    # @param [Components::Map] map
    # @param [Moon::EntitySystem::Entity] entity
    def post_move(map, entity)
      entity.comp(:mapobj, :transfer) do |mapobj, transfer|
        # is this entity already pending a transfer?
        return if transfer.pending

        node = map.transfer_node_at(*mapobj.position)
        # is there a node?
        return unless node

        dest_map_id = node['map_id']
        x = node['x']
        y = node['y']
        if dest_map = game.database[dest_map_id]
          transfer.x = x
          transfer.y = y
          transfer.map_id = dest_map.id
          transfer.pending = true
        else
          puts "WARN: Transfer to #{dest_map_id} failed, no such map"
        end
      end
    end

    # Updates the movement entities
    #
    # @param [Float] delta
    def update(delta)
      level_entity = world.filter(:level).first
      map = level_entity[:level].map
      world.filter :movement, :mapobj do |entity|
        entity.comp(:movement, :mapobj) do |movement, mapobj|
          vect = movement.vect
          if mapobj.real_position == mapobj.position
            if mapobj.moving
              mapobj.moving = false
              post_move(map, entity)
            end
            unless vect.zero?
              x = mapobj.position.x + vect.x
              y = mapobj.position.y + vect.y
              passage = map.passage_at(x, y)
              if passage > 0
                mapobj.position.set(x, y)
              end
            end
          end

          if mapobj.real_position != mapobj.position
            mapobj.moving = true
            real, act = mapobj.real_position, mapobj.position
            spd = delta * 5
            real.x = real.x.step_to(act.x, spd)
            real.y = real.y.step_to(act.y, spd)
          end
        end
      end
    end
  end
end
