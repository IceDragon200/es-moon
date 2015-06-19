require 'scripts/entity_system/component'

class TransformComponent < ES::EntitySystem::Component
  register :transform

  field :position, type: Moon::Vector3
end
