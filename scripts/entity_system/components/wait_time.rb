require 'scripts/entity_system/component'

class WaitTimeComponent < ES::EntitySystem::Component
  register :wait_time

  field :value, type: Integer, default: 0
  field :max,   type: Integer, default: 0
  field :reset, type: Integer, default: 0
end
