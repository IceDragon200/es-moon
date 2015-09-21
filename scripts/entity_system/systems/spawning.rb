require 'scripts/entity_system/system'
require 'scripts/entity_system/system/processing'
require 'scripts/entity_system/components/spawner'

module Systems
  class Spawning < Base
    include ES::EntitySystem::System::Processing
    register :spawning

    def filtered(&block)
      world.filter(:spawner, :transform, &block)
    end

    def process(entity, delta)
      spawner = entity[:spawner]
      spawner.timer.update(delta)
      if spawner.timer.done?
        template = spawner.template
        world.spawn template do |e|
          e[:transform].position = entity[:transform].position
        end
        spawner.timer.restart
      end
    end
  end
end
