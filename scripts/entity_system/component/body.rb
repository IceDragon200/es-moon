class BodyComponent
  include Moon::EntitySystem::Component
  register :body

  field :speed, type: Float, default: 1.0
end
