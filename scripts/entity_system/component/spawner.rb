class SpawnerComponent
  include Moon::EntitySystem::Component
  register :spawner

  field :template, type: Moon::EntitySystem::Entity
  field :timer,    type: Moon::Timer
end
