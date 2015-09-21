require 'scripts/entity_system/component'

module Components
  class Team < Base
    register :team

    field :number, type: Integer, default: Enum::Team::NEUTRAL
  end
end
