require 'scripts/entity_system/system'
require 'scripts/entity_system/components/transfer'
require 'scripts/entity_system/components/mapobj'

module Systems
  # System responsible for handling entity transfers between maps
  class Transfer < Base
    register :transfer

    def update(delta)
      world.filter(:mapobj, :transfer) do |entity|
        entity.comp(:mapobj, :transfer) do |mapobj, transfer|
          if transfer.pending
            mapobj.map_id = transfer.map_id
            mapobj.position.x = transfer.x
            mapobj.position.y = transfer.y
            transfer.pending = false
          end
        end
      end

      world.filter(:player, :mapobj) do |player_entity|
        world.filter(:level) do |entity|
          entity.comp(:level) do |level|
            map_id = player_entity[:mapobj].map_id
            if map_id != level.map.id
              level.map = game.database[map_id]
            end
          end
        end
      end
    end
  end
end
