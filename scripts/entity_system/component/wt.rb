class WtComponent
  include Moon::EntitySystem::Component
  register :wt

  field :value, type: Integer, default: 0
  field :max,   type: Integer, default: 0
end
