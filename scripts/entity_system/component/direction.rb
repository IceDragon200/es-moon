class DirectionComponent
  include Moon::EntitySystem::Component

  # Enum::Direction
  field :dir, type: Integer, default: Enum::Direction::DOWN
end
