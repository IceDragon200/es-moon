require 'scripts/entity_system/component'

class SpawnerComponent < ES::EntitySystem::Component
  register :spawner

  field :template, type: Moon::EntitySystem::Entity
  field :timer,    type: Moon::Timer
end
