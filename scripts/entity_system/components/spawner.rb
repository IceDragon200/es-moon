require 'scripts/entity_system/component'

module Components
  class Spawner < Base
    register :spawner

    field :template, type: Moon::EntitySystem::Entity
    field :timer,    type: Moon::Timer
  end
end
