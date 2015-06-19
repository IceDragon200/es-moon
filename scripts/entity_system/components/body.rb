require 'scripts/entity_system/component'

class BodyComponent < ES::EntitySystem::Component
  register :body

  field :speed, type: Float, default: 1.0
end
