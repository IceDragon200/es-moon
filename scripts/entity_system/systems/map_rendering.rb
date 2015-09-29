require 'scripts/models/tileset'
require 'scripts/entity_system/system'
require 'scripts/entity_system/components/level'

module Systems
  class MapRendering < Base
    register :map_rendering

    def post_initialize
      super
      @last_map = nil
      @tilemap = Moon::Tilemap.new
    end

    def render(x, y, z)
      world.filter :level do |map_entity|
        map = map_entity[:level].map
        if @last_map != map
          tileset = game.database[map.tileset_id].as(Models::Tileset)
          spritesheet = game.spritesheets[tileset.spritesheet_id]
          @tilemap.set(
            data: map.data.blob,
            datasize: map.data.sizes,
            tileset: spritesheet)
          @last_map = map
        end
        @tilemap.render 0, 0, 0
      end
    end
  end
end
