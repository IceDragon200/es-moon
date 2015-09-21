require 'scripts/entity_system/system'
require 'scripts/entity_system/system/processing'
require 'scripts/entity_system/components/transform'
require 'scripts/entity_system/components/navigation'
require 'scripts/entity_system/components/body'

module Systems
  class Movement < Base
    include ES::EntitySystem::System::Processing
    register :movement

    def init
      super
      @sprite = Moon::Sprite.new(TextureCache.ui('map_editor_cursor.png'))
    end

    def filtered(&block)
      world.filter(:transform, :navigation, :body, &block)
    end

    def process(entity, delta)
      entity.comp(:transform, :navigation, :body) do |t, n, b|
        dist = t.position.distance(n.destination)
        if dist.abs > 1e-1
          v = t.position.turn_towards(n.destination)
          t.position = t.position + (v * b.speed * delta)
        end
      end
    end
  end
end
