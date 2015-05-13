class TargetComponent
  include Moon::EntitySystem::Component
  register :target

  field :target, type: Moon::EntitySystem::Entity, default: nil
end
