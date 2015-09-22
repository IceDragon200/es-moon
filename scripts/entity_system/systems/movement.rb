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
      return # TODO
      entity.comp(:mapobj, :transfer) do |mapobj, transfer|
        # is this entity already pending a transfer?
        return if transfer.pending

        zone = map.transfer_zone_at(*mapobj.position)
        # is there a zone?
        return unless zone

        anchor = zone.properties['anchor']
        dest_map_id, dest_name = anchor.split("#")
        if dest_map = game.data["maps/#{dest_map_id}"]
          if dest_zone = dest_map.anchor_zone(dest_name)
            transfer.x = dest_zone.rect.x
            transfer.y = dest_zone.rect.y
            transfer.map_id = dest_map.id
            transfer.pending = true
          else
            puts "WARN: Transfer to #{anchor} failed, no such anchor (name: #{dest_name}) in dest map"
          end
        else
          puts "WARN: Transfer to #{dest_map_id} failed, no such map"
        end
      end
    end

    def get_map(map_id)
      @map_cache[map_id] ||= begin
        e = world.filter(:map).find do |m|
          m[:map].map.id == map_id
        end
        e && e[:map].map
      end
    end

    # Updates the movement entities
    #
    # @param [Float] delta
    def update(delta)
      world.filter :movement, :mapobj do |entity|
        entity.comp(:movement, :mapobj) do |movement, mapobj|
          map = get_map(mapobj.map_id)
          unless map
            puts "WARN: Entity is present in an invalid map (#{mapobj.map_id})"
            next
          end
          vect = movement.vect
          unless vect.zero?
            x = mapobj.position.x + vect.x
            y = mapobj.position.y + vect.y
            passage = map.passage_at(x, y)
            if passage > 0
              mapobj.position.set(x, y)
              post_move(map, entity)
            end
            vect.zero!
          end
        end
      end
    end
  end
end
