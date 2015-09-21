require 'scripts/entity_system/component'

module Components
  class Direction < Base
    register :direction

    # Enum::Direction
    field :dir, type: Integer, default: Enum::Direction::DOWN
  end
end
