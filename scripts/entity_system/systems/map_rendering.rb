require 'scripts/models/tileset'
require 'scripts/entity_system/system'
require 'scripts/entity_system/components/map'

module Systems
  class MapRendering < Base
    register :map_rendering

    def post_initialize
      super
      @last_map = nil
      @tilemap = Moon::Tilemap.new
      @spritesheet_cache = {}
    end

    def render(x, y, z, options)
      world.filter :map do |map_entity|
        map = map_entity[:map].map
        if @last_map != map
          tileset = game.database[map.tileset_id].as(Models::Tileset)
          spritesheet = @spritesheet_cache[tileset.spritesheet_id] ||= begin
            Moon::Spritesheet.new(game.texture_cache[tileset.filename], tileset.cell_w, tileset.cell_h)
          end
          @tilemap.set data: map.data.blob, datasize: map.data.sizes, tileset: spritesheet
          @last_map = map
        end
        @tilemap.render 0, 0, 0
      end
    end
  end
end
