require 'scripts/entity_system/component'

class TargetComponent < ES::EntitySystem::Component
  register :target

  field :target, type: Moon::EntitySystem::Entity, default: nil
end
