class TransformComponent
  include Moon::EntitySystem::Component
  register :transform

  field :position, type: Moon::Vector3
end
