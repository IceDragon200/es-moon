# communication interface between an entity and its renderer
class SpriteComponent
  include Moon::EntitySystem::Component
  register :sprite

  # last known rendered bounds
  field :bounds, type: Moon::Cuboid, default: proc { |t| t.new }
end
