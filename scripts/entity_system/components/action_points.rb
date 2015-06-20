require 'scripts/entity_system/component'

class ActionPointsComponent < ES::EntitySystem::Component
  register :action_points

  field :value, type: Integer, default: 0
  field :max,   type: Integer, default: 0
  field :regen, type: Integer, default: 3
end
