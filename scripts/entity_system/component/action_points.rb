class ActionPointsComponent
  include Moon::EntitySystem::Component
  register :action_points

  field :value, type: Integer, default: 0
  field :max,   type: Integer, default: 0
end
