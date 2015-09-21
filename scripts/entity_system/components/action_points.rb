require 'scripts/entity_system/component'

module Components
  class ActionPoints < Base
    register :action_points

    field :value, type: Integer, default: 0
    field :max,   type: Integer, default: 0
    field :regen, type: Integer, default: 3
  end
end
