require 'scripts/entity_system/component'

class DirectionComponent < ES::EntitySystem::Component
  register :direction

  # Enum::Direction
  field :dir, type: Integer, default: Enum::Direction::DOWN
end
