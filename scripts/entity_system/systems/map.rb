require 'scripts/entity_system/system'
require 'scripts/entity_system/system/processing'
require 'scripts/entity_system/components/mapobj'
require 'scripts/entity_system/components/transform'

module Systems
  # The Map system is responsible for converting mapobjs map positions to
  # screen positions
  class Map < Base
    include Processing

    register :map

    def filtered(&block)
      world.filter(:mapobj, :transform, &block)
    end

    def process(entity, delta)
      entity.comp(:mapobj, :transform) do |m, t|
        t.position.set(m.position * 32, 0)
      end
    end
  end
end
