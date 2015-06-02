class WaitTimeComponent
  include Moon::EntitySystem::Component
  register :wait_time

  field :value, type: Integer, default: 0
  field :max,   type: Integer, default: 0
end
