require 'scripts/entity_system/component'

class TeamComponent < ES::EntitySystem::Component
  register :team

  field :number, type: Integer, default: Enum::Team::NEUTRAL
end
